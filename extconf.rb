require 'mkmf'

have_library('gcrypt', 'gcry_errno') and
  create_makefile('gcrypt')

