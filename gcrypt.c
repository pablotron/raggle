/************************************************************************/
/* Copyright (c) 2002 Paul Duncan                                       */
/*                                                                      */
/* Permission is hereby granted, free of charge, to any person          */
/* obtaining a copy of this software and associated documentation files */
/* (the "Software"), to deal in the Software without restriction,       */
/* including without limitation the rights to use, copy, modify, merge, */
/* publish, distribute, sublicense, and/or sell copies of the Software, */
/* and to permit persons to whom the Software is furnished to do so,    */
/* subject to the following conditions:                                 */
/*                                                                      */
/* The above copyright notice and this permission notice shall be       */
/* included in all copies of the Software, its documentation and        */
/* marketing & publicity materials, and acknowledgment shall be given   */
/* in the documentation, materials and software packages that this      */
/* Software was used.                                                   */
/*                                                                      */
/* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,      */
/* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF   */
/* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND                */
/* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY     */
/* CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, */
/* TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE    */
/* SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.               */
/************************************************************************/

#include <ruby.h>
#include <gcrypt.h>

#define VERSION "0.1.0"
#define UNUSED(a) ((void) (a))

static VALUE mGc,
             cSexp,
             cMPI,
             cCipher,
             cMD;

static void handle_error(const int num, const int ofs) {
  const char *str;

  str = gcry_strerror(num);
  if (ofs >= 0)
    rb_raise(rb_eException, "Gcrypt Error: %s at offset %d", str, ofs);
  else
    rb_raise(rb_eException, "Gcrypt Error: %s", str);
}

static VALUE gc_errno(VALUE self) {
  return INT2FIX(gcry_errno());
}

static VALUE gc_strerror(VALUE self, VALUE err) {
  return rb_str_new2(gcry_strerror(NUM2INT(err)));
}

static VALUE gc_control(VALUE self, int argc, VALUE *argv) {
  VALUE err;
  return err;
}

/************************/
/* Gcrypt::Sexp methods */
/************************/

/*
 * Return a new Gcrypt::Sexp object from a string.
 *
 * Create a new S-expression object from a buffer.  With AUTODETECT set
 * to 0, the data in the buffer is expected to be in canonized format.
 *
 * Example:
 *   sexp = Gcrypt::Sexp.new buffer, false
 *
 */
VALUE gc_sexp_new(VALUE klass, VALUE buf, VALUE autodetect) {
  GcrySexp *sexp;
  VALUE self;
  char *ptr;
  int len, err;

  ptr = RSTRING(buf)->ptr; len = RSTRING(buf)->len;
  if ((err = gcry_sexp_new(sexp, ptr, len, autodetect != Qfalse)) != 0)
    handle_error(err, -1);

  self = Data_Wrap_Struct(klass, 0, gcry_sexp_release, sexp);
  rb_obj_call_init(self, 0, NULL);

  return self;
}

/*
 * Return a new Gcrypt::Sexp object from a string.
 *
 * Create a new S-expression object from a buffer.  With AUTODETECT set
 * to 0, the data in the buffer is expected to be in canonized format.
 *
 * Example:
 *   sexp = Gcrypt::Sexp.sscan buffer
 *
 */
VALUE gc_sexp_sscan(VALUE klass, VALUE buf, VALUE autodetect) {
  GcrySexp *sexp;
  VALUE self;
  char *ptr;
  int len, *ofs, err;

  ptr = RSTRING(buf)->ptr; len = RSTRING(buf)->len;
  if ((err = gcry_sexp_scan(sexp, ofs, ptr, len)) != 0)
    handle_error(err, *ofs);

  self = Data_Wrap_Struct(klass, 0, gcry_sexp_release, sexp);
  rb_obj_call_init(self, 0, NULL);

  return self;
}

/*
 * Gcrypt::Sexp constructor.
 *
 * This method is currently empty.  You should never call this method
 * directly unless you're instantiating a derived class (ie, you know
 * what you're doing).
 *
 */
static VALUE gc_sexp_init(VALUE self) {
  return self;
}

static VALUE gc_sexp_canon_len(VALUE klass, VALUE buf) {
  
}

static VALUE gc_sexp_sprint(VALUE self, VALUE mode, VALUE buf) {
  GcrySexp *sexp;
  int len;

  Data_Get_Struct(self, GcrySexp, sexp);
  len 
  
}

void Init_gcrypt(void) {
  /* Gcrypt module */
  mGc = rb_define_module("Gcrypt");
  rb_define_const(mGc, "VERSION", rb_str_new2(GCRYPT_VERSION));
  rb_define_const(mGc, "GCRYPT_VERSION", rb_str_new2(GCRYPT_VERSION));

  /* ctl constants */
  rb_define_const(mGc, "CTL_SET_KEY", INT2FIX(GCRYCTL_SET_KEY));
  rb_define_const(mGc, "CTL_SET_IV", INT2FIX(GCRYCTL_SET_IV));
  rb_define_const(mGc, "CTL_CFB_SYNC", INT2FIX(GCRYCTL_CFB_SYNC));
  rb_define_const(mGc, "CTL_RESET", INT2FIX(GCRYCTL_RESET));
  rb_define_const(mGc, "CTL_FINALIZE", INT2FIX(GCRYCTL_FINALIZE));
  rb_define_const(mGc, "CTL_GET_KEYLEN", INT2FIX(GCRYCTL_GET_KEYLEN));
  rb_define_const(mGc, "CTL_GET_BLKLEN", INT2FIX(GCRYCTL_GET_BLKLEN));
  rb_define_const(mGc, "CTL_TEST_ALGO", INT2FIX(GCRYCTL_TEST_ALGO));
  rb_define_const(mGc, "CTL_IS_SECURE", INT2FIX(GCRYCTL_IS_SECURE));
  rb_define_const(mGc, "CTL_GET_ASNOID", INT2FIX(GCRYCTL_GET_ASNOID));
  rb_define_const(mGc, "CTL_ENABLE_ALGO", INT2FIX(GCRYCTL_ENABLE_ALGO));
  rb_define_const(mGc, "CTL_DISABLE_ALGO", INT2FIX(GCRYCTL_DISABLE_ALGO));
  rb_define_const(mGc, "CTL_DUMP_RANDOM_STATS", INT2FIX(GCRYCTL_DUMP_RANDOM_STATS));
  rb_define_const(mGc, "CTL_DUMP_SECMEM_STATS", INT2FIX(GCRYCTL_DUMP_SECMEM_STATS));
  rb_define_const(mGc, "CTL_GET_ALGO_NPKEY", INT2FIX(GCRYCTL_GET_ALGO_NPKEY));
  rb_define_const(mGc, "CTL_GET_ALGO_NSKEY", INT2FIX(GCRYCTL_GET_ALGO_NSKEY));
  rb_define_const(mGc, "CTL_GET_ALGO_NSIGN", INT2FIX(GCRYCTL_GET_ALGO_NSIGN));
  rb_define_const(mGc, "CTL_GET_ALGO_NENCR", INT2FIX(GCRYCTL_GET_ALGO_NENCR));
  rb_define_const(mGc, "CTL_SET_VERBOSITY", INT2FIX(GCRYCTL_SET_VERBOSITY));
  rb_define_const(mGc, "CTL_SET_DEBUG_FLAGS", INT2FIX(GCRYCTL_SET_DEBUG_FLAGS));
  rb_define_const(mGc, "CTL_CLEAR_DEBUG_FLAGS", INT2FIX(GCRYCTL_CLEAR_DEBUG_FLAGS));
  rb_define_const(mGc, "CTL_USE_SECURE_RNDPOOL", INT2FIX(GCRYCTL_USE_SECURE_RNDPOOL));
  rb_define_const(mGc, "CTL_DUMP_MEMORY_STATS", INT2FIX(GCRYCTL_DUMP_MEMORY_STATS));
  rb_define_const(mGc, "CTL_INIT_SECMEM", INT2FIX(GCRYCTL_INIT_SECMEM));
  rb_define_const(mGc, "CTL_TERM_SECMEM", INT2FIX(GCRYCTL_TERM_SECMEM));
  rb_define_const(mGc, "CTL_DISABLE_SECMEM_WARN", INT2FIX(GCRYCTL_DISABLE_SECMEM_WARN));
  rb_define_const(mGc, "CTL_SUSPEND_SECMEM_WARN", INT2FIX(GCRYCTL_SUSPEND_SECMEM_WARN));
  rb_define_const(mGc, "CTL_RESUME_SECMEM_WARN	", INT2FIX(GCRYCTL_RESUME_SECMEM_WARN	));
  rb_define_const(mGc, "CTL_DROP_PRIVS		", INT2FIX(GCRYCTL_DROP_PRIVS		));
  rb_define_const(mGc, "CTL_ENABLE_M_GUARD	", INT2FIX(GCRYCTL_ENABLE_M_GUARD	));
  rb_define_const(mGc, "CTL_START_DUMP		", INT2FIX(GCRYCTL_START_DUMP		));
  rb_define_const(mGc, "CTL_STOP_DUMP		", INT2FIX(GCRYCTL_STOP_DUMP		));
  rb_define_const(mGc, "CTL_GET_ALGO_USAGE", INT2FIX(GCRYCTL_GET_ALGO_USAGE));
  rb_define_const(mGc, "CTL_IS_ALGO_ENABLED", INT2FIX(GCRYCTL_IS_ALGO_ENABLED));
  rb_define_const(mGc, "CTL_DISABLE_INTERNAL_LOCKING", INT2FIX(GCRYCTL_DISABLE_INTERNAL_LOCKING));
  rb_define_const(mGc, "CTL_DISABLE_SECMEM", INT2FIX(GCRYCTL_DISABLE_SECMEM));
  rb_define_const(mGc, "CTL_INITIALIZATION_FINISHED", INT2FIX(GCRYCTL_INITIALIZATION_FINISHED));
  rb_define_const(mGc, "CTL_INITIALIZATION_FINISHED_P", INT2FIX(GCRYCTL_INITIALIZATION_FINISHED_P));
  rb_define_const(mGc, "CTL_ANY_INITIALIZATION_P", INT2FIX(GCRYCTL_ANY_INITIALIZATION_P));
  rb_define_const(mGc, "CTL_SET_CBC_CTS", INT2FIX(GCRYCTL_SET_CBC_CTS));

  rb_define_singleton_method(mGc, "control", gc_control, -1);
  rb_define_singleton_method(mGc, "errno", gc_errno, 0);

  /* Sexp class */
  cSexp = rb_define_class_under(mGc, "Sexp", rb_cObject);
  rb_define_singleton_method(cSexp, "new", gc_sexp_new, 2);
  rb_define_singleton_method(cSexp, "sscan", gc_sexp_sscan, 2);
  rb_define_method(cSexp, "initialize", gc_sexp_init, 0);

  rb_define_const(cSexp, "SEXP_FMT_DEFAULT", GCRYSEXP_FMT_DEFAULT);
  rb_define_const(cSexp, "SEXP_FMT_CANON	", GCRYSEXP_FMT_CANON	);
  rb_define_const(cSexp, "SEXP_FMT_BASE64", GCRYSEXP_FMT_BASE64);
  rb_define_const(cSexp, "SEXP_FMT_ADVANCED", GCRYSEXP_FMT_ADVANCED);
  
  rb_define_singleton_method(cSexp, "canon_len", gc_sexp_canon_len, 1);
  rb_define_method(cSexp, "sprint", gc_sexp_sprint, 1);
  rb_define_method(cSexp, "dump", gc_sexp_dump, 0);
  rb_define_method(cSexp, "cons", gc_sexp_cons, 1);
  rb_define_method(cSexp, "alist", gc_sexp_alist, 1);
  rb_define_method(cSexp, "append", gc_sexp_append, 1);
  rb_define_method(cSexp, "prepend", gc_sexp_prepend, 1);
  rb_define_method(cSexp, "find_token", gc_sexp_find_token, 1);
  rb_define_method(cSexp, "length", gc_sexp_length, 1);
  rb_define_method(cSexp, "nth", gc_sexp_nth, 1);
  rb_define_method(cSexp, "[]", gc_sexp_nth, 1);
  rb_define_method(cSexp, "car", gc_sexp_car, 1);
  rb_define_method(cSexp, "cdr", gc_sexp_cdr, 1);
  rb_define_method(cSexp, "cadr", gc_sexp_cadr, 1);
  rb_define_method(cSexp, "nth_data", gc_sexp_nth_data, 1);
  rb_define_method(cSexp, "nth_mpi", gc_sexp_nth_mpi, 1);

  /* MPI class */
  cMPI = rb_define_class_under(mGc, "MPI", rb_cObject);
  /*
  rb_define_singleton_method(cMPI, "new", gc_mpi_new, 1);
  rb_define_singleton_method(cMPI, "snew", gc_mpi_snew, 1);
  rb_define_method(cMPI, "initialize", gc_mpi_init, 0);

  rb_define_method(cMPI, "copy", gc_mpi_copy, 0);
  rb_define_alias(cMPI, "dup", "copy");
  */
  
  /* Cipher class */
  cCipher = rb_define_class_under(mGc, "Cipher", rb_cObject);

  /* MD class */
  cMD = rb_define_class_under(mGc, "MD", rb_cObject);
}
