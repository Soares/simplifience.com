"""Kramer (flow + kramdown) mite compiler."""
import os
from collections import OrderedDict
import logging
from functools import partial

from mite.color import color, RED
from mite.compiler import Flow
from mite.util.path import urlify
from subprocess import Popen, PIPE

first = lambda t: t[0]


def url_from(url, relurl):
	return os.path.normpath(os.path.join(os.path.dirname(url), relurl))


def page_name(url, context):
	fallback = os.path.basename(os.path.splitext(url)[0])
	return context.get('title', fallback)

def markdown_link(title, url, classes=()):
	if classes:
		suffix = '{:%s}' % ' '.join('.' + c for c in classes)
	else:
		suffix = ''
	return '[{}]({}){}'.format(title, url, suffix)

def html_link(title, url, classes=()):
	classes = ' '.join(classes)
	attrs = (' class="%s"' % classes) if classes else ''
	return '<a href="{}"{}>{}</a>'.format(url, attrs, title)

class Compiler(Flow):
	"""Compiles files using kramdown."""

	def url_matches(self, relurl, oururl):
		url = urlify(os.path.join(self.destroot, relurl.lstrip('/')))
		url = os.path.splitext(url)[0] + self.extension
		return url == oururl

	def url_in(self, urls, url):
		url = os.path.splitext(url)[0]
		urls = [os.path.splitext(u)[0] for u in urls]
		return url in urls

	def get_context(self, relurl):
		url = urlify(os.path.join(self.destroot, relurl.lstrip('/')))
		url = os.path.splitext(url)[0] + self.extension
		return self.pages[url]

	def link_filter(self, makelink, relurl, title=None, here=False, *classes):
		url = urlify(os.path.join(self.destroot, relurl.lstrip('/')))
		url = os.path.splitext(url)[0] + self.extension
		classes = list(classes)
		if url in self.pages:
			page = self.pages[url]
			if page.get('stub', False):
				classes.append('stub')
			title = title or page.get('title', relurl)
			return makelink(title, url, classes)
		logging.warning(color('MISSING: %s', RED), url)
		classes.append('missing')
		classes.append('stub')
		if hasattr(self, 'view'):
			self.view.depend(self.view.neighbor(relurl))
		return makelink(title or relurl, url, classes)

	def sequence_name(self, relurl, sequence):
		context = self.get_context(relurl)
		return context.get('name_in', {}).get(sequence, context['title'])

	def filters(self):
		filters = super().filters()
		filters[self.name + '_attr'] = filters[self.name]
		filters[self.name] = partial(self.link_filter, markdown_link)
		filters[self.name + '_anchor'] = partial(self.link_filter, html_link)
		filters[self.name + '_is'] = self.url_matches
		filters[self.name + '_in'] = self.url_in
		filters[self.name + '_context'] = self.get_context
		filters[self.name + '_sequence_name'] = self.sequence_name
		return filters

	def related(self, url):
		assert url in self.pages
		rellinks = self.pages[url].get('related', [])
		related = {url_from(url, rellink) for rellink in rellinks}
		for url, page in self.pages.items():
			expanded = (url_from(url, rellink)
					for rellink in page.get('related', []))
			related.update(x for x in expanded if x == url)
		return related

	def all_sequences(self):
		for url, page in self.pages.items():
			if 'sequence' in page and 'stub' not in page:
				yield self.sequence(url)

	def sequences_containing(self, url):
		assert url in self.pages
		if 'sequence' in self.pages[url] and 'stub' not in self.pages[url]:
			yield self.sequence(url)
		for u, p in self.pages.items():
			if u == url or 'sequence' not in p:
				continue
			members = p.get('members', [])
			if any(self.url_matches(url_from(u, m), url) for m in members):
				yield self.sequence(u)

	def sequence(self, url):
		assert url in self.pages
		page = self.pages[url]
		assert 'sequence' in page
		members = page.get('members', [])
		return (page['sequence'], [url] + [url_from(url, m) for m in members])

	def compile(self, view):
		# TODO: This is a hacky way to expose dependencies to the filters.
		self.view = view
		super().compile(view)

	def contextualize(self, context, view):
		context['related'] = self.related(view.url)
		context['sequences'] = OrderedDict(
				sorted(self.sequences_containing(view.url)))
		context['url'] = view.url
		context['allsequences'] = OrderedDict(
				sorted(self.all_sequences()))
		if context['sequences']:
			firstsequence = next(iter(context['sequences']))
			firstposturl = context['sequences'][firstsequence][0]
			context.setdefault('blog', self.pages[firstposturl].get('blog'))
		return context

	def render(self, text):
		proc = Popen(['kramdown'], stdin=PIPE, stdout=PIPE)
		rendered, error = proc.communicate(text.encode('utf-8'))
		if error:
			raise ValueError(error)
		return rendered.decode('utf-8')
