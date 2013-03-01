"""Kramer (flow + kramdown) mite compiler."""
from mite.compilers import Flow
from subprocess import Popen, PIPE

class Compiler(Flow):
	"""Compiles files using kramdown."""

	def render(self, text):
		proc = Popen(['kramdown'], stdin=PIPE, stdout=PIPE)
		rendered, error = proc.communicate(text)
		if error:
			raise ValueError(error)
		return rendered
