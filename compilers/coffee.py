"""Coffeescript mite compiler."""
import logging
import os
import subprocess

from mite.compilers import Javascript

class Compiler(Javascript):
	"""Compiles files using coffeescript."""

	# We ignore the context but don't want to break if the interface changes.
	# pylint: disable-msg=unused-argument
	def write(self, *args, **kwargs):
		logging.info('Brewing %s', self.url)
		logging.debug('from %s', self.source)
		self.mkdir(os.path.dirname(self.destination))
		subprocess.call([
			'coffee',
			'-o', os.path.dirname(self.destination),
			self.source
		], stdout=open(os.devnull, 'w'))
		logging.debug('finished brewing %s', self.destination)
