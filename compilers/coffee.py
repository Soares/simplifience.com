"""Coffeescript mite compiler."""
import logging
import os

from mite.compilers import Javascript

class Compiler(Javascript):
	"""Compiles files using coffeescript."""

	# We ignore the context but don't want to break if the interface changes.
	# pylint: disable-msg=unused-argument
	def write(self, *args, **kwargs):
		self.mkdir(os.path.dirname(self.destination))
		logging.info('Brewing %s', self.destination)
		logging.debug('from %s', self.source)
		subprocess.call([
			'coffee',
			'-o', os.path.dirname(self.destination),
			self.source
		], stdout=open(os.devnull, 'w'))
		logging.debug('finished brewing %s', self.destination)
