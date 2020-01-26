# jupyter_function.py
# Call eXist-db from Jupyter notebook cell
#
# To use (from same directory):
#   from jupyter_function import run_xquery as xq
#   xq(...)

import requests
from pygments import highlight
from pygments.lexers import XQueryLexer
from pygments.formatters import HtmlFormatter
from IPython.core.display import display, HTML
import regex

# Send the query to eXist-db, serializing the results using a standard output method (default: adaptive)
# Standard serialization methods: html, json, xml, adaptive, text
# The html output method is rendered as HTML; for others, syntax highlighting is applied
def run_xquery(query, output_method='adaptive'):
  url = 'http://localhost:8080/exist/apps/atom-editor/execute'
  parameters = {
    'qu': query,
    'output': output_method
  }
  r = requests.post(url, data = parameters)
  if r.status_code == 400: # serialization error
    print(regex.findall(r'(?<=<message>).*(?=\[)', r.text, regex.S)[0])
  elif r.status_code == 500: # syntax error in query input
    display(HTML(r.text))
  elif output_method == 'html':
    display(HTML(r.text))
  else:
    display(HTML('<style>{pygments_css}</style>'.format(pygments_css=HtmlFormatter().get_style_defs('.highlight'))))
    display(HTML(data=highlight(r.text, XQueryLexer(), HtmlFormatter())))

# If syntax highlighting ever slows down results, replace with:
#    print(r.text)
