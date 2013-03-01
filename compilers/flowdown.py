"""Flowdown (flow + markdown) mite compiler."""
from mite.compilers import Flow
import markdown

class Compiler(Flow):
	"""Compiles files using markdown."""

	def render(self, text):
		return markdown.markdown(text)
