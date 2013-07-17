"""Stylus mite compiler."""
import re
import logging
import os
import subprocess

from mite.compiler import Contained, CSS


class Compiler(Contained, CSS):
	"""Compiles files using stylus."""

	def compile(self, view):
		super().compile(view)
		if os.path.basename(view.source).startswith('_'):
			logging.debug('Skipping %s (starts with _)', view.url)
		else:
			logging.info('Styling %s', view.url)
			view.execute([
				'stylus',
				'-o', os.path.dirname(view.destination),
				view.source], stdout=subprocess.DEVNULL)
		styl = view.read()
		if IMPORT_VARIABLE.match(styl):
			logging.warning('Unresolvable dependency.')
			logging.warning('%s appears to be @importing a variable.', view.url)
		for i in map(view.neighbor, imports(styl)):
			logging.debug('%s will watch %s', view.url, i.url)
			view.depend(i.source)


def imports(stylus):
	"""
	Scrapes a stylus text for imports and yields all the files that they could
	potentially refer to. Import strings, not variables, or it will choke.

	>>> tuple(imports('''
	... @import 'a'
	... @import "b/one"
	... '''))
	('a.styl', 'a/index.styl', 'b/one.styl', 'b/one/index.styl')
	>>> tuple(imports('''
	... @import url('c')
	... @import url "d/two"
	... '''))
	('c.styl', 'c/index.styl', 'd/two.styl', 'd/two/index.styl')

	>>> IMPORT_STATEMENT.match('@import "some/url"').groups()
	('"', 'some/url')

	>>> IMPORT_VARIABLE.match('@import "some/url"')
	>>> IMPORT_VARIABLE.match('@import some/url') is not None
	True

	"""
	for _, filename in IMPORT_STATEMENT.findall(stylus):
		if filename.endswith('.css'):
			yield filename
			yield os.path.splitext(filename)[0] + '.styl'
		else:
			yield filename + '.styl'
			yield os.path.join(filename, 'index.styl')


IMPORT_STATEMENT = re.compile(r"""
		^\s*@import\s+			# Duh.
		(?:url					# CSS allows you to say 'url'
			(?:\s*\(\s*|\s+)	# Open paren is optional.
		)?						# url() is optional.
		(["'])					# GROUP 1: An opening quote.
		((?:[^\1\\\n]|\\.)*)	# GROUP 2: The import file.
		\1						# Matching quote.
		""", re.VERBOSE | re.MULTILINE)
IMPORT_VARIABLE = re.compile(r"""
		^\s*@import\s+			# See above.
		(?:url
			(?:\s*\(\s*|\s+)
		)?
		[a-zA-Z0-9_$]+			# Looks like a variable.
		""", re.VERBOSE | re.MULTILINE)
