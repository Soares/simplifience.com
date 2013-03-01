"""Jinja + markdown mite compiler."""
from mite.compilers import Jinja
import markdown

class Compiler(Jinja):
	"""Compiles files using markdown."""

	def parse(self, text):
		return markdown.markdown(text), {}
