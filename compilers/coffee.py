"""Coffeescript mite compiler."""
import logging
import os

from mite.compiler import Contained, Javascript

class Compiler(Contained, Javascript):
	"""Compiles files using coffeescript."""

	def compile(self, view):
		super().compile(view)
		logging.info('Brewing %s', view.url)
		view.execute([
			'coffee',
			'-o', os.path.dirname(view.destination),
			view.source
		])
