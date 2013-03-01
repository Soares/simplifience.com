"""Stylus mite compiler."""
import logging
import os

from mite.compilers import CSS
import subprocess

class Compiler(CSS):
	"""Compiles files using stylus."""

	# We ignore the context but don't want to break if the interface changes.
	# pylint: disable-msg=unused-argument
	def write(self, *args, **kwargs):
		self.mkdir(os.path.dirname(self.destination))
		logging.info('Styling %s', self.destination)
		logging.debug('from %s', self.source)
		subprocess.call([
				'stylus',
				'-o', os.path.dirname(self.destination),
				self.source
		], stdout=open(os.devnull, 'w'))
		logging.debug('finished styling %s', self.destination)
