/*                This file is part of the scheme package.
            Copyright (C) 1998-99 Stephane HILLION - hillion@essi.fr
                 http://www.essi.fr/~hillion/scheme-package
   scheme package is free software. You can redistribute it and/or modify it 
  under the terms of the GNU General Public License as published by the Free
  Software  Foundation;  either  version  2, or (at your option)  any  later 
  version. The  scheme package  is distributed in the hope that  it will  be
  useful, but  WITHOUT ANY WARRANTY;  without  even  the implied warranty of
  MERCHANTABILITY or  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
  Public License for  more  details.   You  should  have  received a copy of
  the GNU General Public  License  along  with the scheme package;   see the
  file COPYING.  If not,  write to the Free  Software  Foundation,  Inc., 59
  Temple Place - Suite 330, Boston, MA 02111-1307, USA.
*/
package scheme.kernel;

import scheme.primitives.*;

/**
 * A kernel with r4rs standard functions in the environment
 *
 * @author  Stephane Hillion
 * @version 1.1 - 1998/12/10
 */
public class ScmStandardKernel extends ScmKernel {
  /**
   * Create a new kernel
   */
  public ScmStandardKernel () {
    define ("+",                              ScmAdd.INSTANCE);
    define ("-",                              ScmSub.INSTANCE);
    define ("*",                              ScmMul.INSTANCE);
    define ("/",                              ScmDiv.INSTANCE);
    define ("=",                              ScmEqual.INSTANCE);
    define (">",                              ScmGreater.INSTANCE);
    define ("<",                              ScmLess.INSTANCE);
    define (">=",                             ScmGreaterOrEqual.INSTANCE);
    define ("<=",                             ScmLessOrEqual.INSTANCE);
    define ("abs",                            ScmAbs.INSTANCE);
    define ("acos",                           ScmAcos.INSTANCE);
    define ("and",                            ScmAnd.INSTANCE);
    define ("angle",                          new ScmNotImplemented ("angle"));
    define ("append",                         ScmAppend.INSTANCE);
    define ("apply",                          ScmApply.INSTANCE);
    define ("asin",                           ScmAsin.INSTANCE);
    define ("assoc",                          ScmAssoc.INSTANCE);
    define ("assq" ,                          ScmAssq.INSTANCE);
    define ("assv" ,                          ScmAssq.INSTANCE);
    define ("atan",                           ScmAtan.INSTANCE);
    define ("begin",                          ScmBegin.INSTANCE);
    define ("boolean?",                       ScmIsBoolean.INSTANCE);
    define ("call-with-current-continuation", ScmCallCC.INSTANCE);
    define ("call-with-input-file",           ScmCallWithInputFile.INSTANCE);
    define ("call-with-output-file",          ScmCallWithOutputFile.INSTANCE);
    define ("call/cc",                        ScmCallCC.INSTANCE);
    define ("case",                           ScmCase.INSTANCE);
    define ("caaaar",                         ScmCxr.CAAAAR);
    define ("caaadr",                         ScmCxr.CAAADR);
    define ("caaar",                          ScmCxr.CAAAR);
    define ("caadar",                         ScmCxr.CAADAR);
    define ("caaddr",                         ScmCxr.CAADDR);
    define ("caadr",                          ScmCxr.CAADR);
    define ("caar",                           ScmCxr.CAAR);
    define ("cadaar",                         ScmCxr.CADAAR);
    define ("cadadr",                         ScmCxr.CADADR);
    define ("cadar",                          ScmCxr.CADAR);
    define ("caddar",                         ScmCxr.CADDAR);
    define ("cadddr",                         ScmCxr.CADDDR);
    define ("caddr",                          ScmCxr.CADDR);
    define ("cadr",                           ScmCxr.CADR);
    define ("cdaaar",                         ScmCxr.CDAAAR);
    define ("cdaadr",                         ScmCxr.CDAADR);
    define ("cdaar",                          ScmCxr.CDAAR);
    define ("cdadar",                         ScmCxr.CDADAR);
    define ("cdaddr",                         ScmCxr.CDADDR);
    define ("cdadr",                          ScmCxr.CDADR);
    define ("cdar",                           ScmCxr.CDAR);
    define ("cddaar",                         ScmCxr.CDDAAR);
    define ("cddadr",                         ScmCxr.CDDADR);
    define ("cddar",                          ScmCxr.CDDAR);
    define ("cdddar",                         ScmCxr.CDDDAR);
    define ("cddddr",                         ScmCxr.CDDDDR);
    define ("cdddr",                          ScmCxr.CDDDR);
    define ("cddr",                           ScmCxr.CDDR);
    define ("car",                            ScmCar.INSTANCE);
    define ("cdr",                            ScmCdr.INSTANCE);
    define ("ceiling",                        ScmCeiling.INSTANCE);
    define ("char?",                          ScmIsChar.INSTANCE);
    define ("char=?",                         ScmIsCharEqual.INSTANCE);
    define ("char>?",                         ScmIsCharGreater.INSTANCE);
    define ("char<?",                         ScmIsCharLess.INSTANCE);
    define ("char>=?",                        ScmIsCharGreaterOrEqual.INSTANCE);
    define ("char<=?",                        ScmIsCharLessOrEqual.INSTANCE);
    define ("char-ci=?",                      ScmIsCharCIEqual.INSTANCE);
    define ("char-ci>?",                      ScmIsCharCIGreater.INSTANCE);
    define ("char-ci<?",                      ScmIsCharCILess.INSTANCE);
    define ("char-ci>=?",                     ScmIsCharCIGreaterOrEqual.INSTANCE);
    define ("char-ci<=?",                     ScmIsCharCILessOrEqual.INSTANCE);
    define ("char-alphabetic?",               ScmIsCharAlphabetic.INSTANCE);
    define ("char-downcase",                  ScmCharDowncase.INSTANCE);
    define ("char->integer",                  ScmCharToInteger.INSTANCE);
    define ("char-lower-case?",               ScmIsCharLowerCase.INSTANCE);
    define ("char-numeric?",                  ScmIsCharNumeric.INSTANCE);
    define ("char-upper-case?",               ScmIsCharUpperCase.INSTANCE);
    define ("char-upcase",                    ScmCharUpcase.INSTANCE);
    define ("char-whitespace?",               ScmIsCharWhitespace.INSTANCE);
    define ("close-input-port",               ScmCloseInputPort.INSTANCE);
    define ("close-output-port",              ScmCloseOutputPort.INSTANCE);
    define ("complex?",                       new ScmNotImplemented ("complex?"));
    define ("cond",                           ScmCond.INSTANCE);
    define ("cons",                           ScmCons.INSTANCE);
    define ("cos",                            ScmCos.INSTANCE);
    define ("current-input-port",             ScmCurrentInputPort.INSTANCE);
    define ("current-output-port",            ScmCurrentOutputPort.INSTANCE);
    define ("define",                         ScmDefine.INSTANCE);
    define ("delay",                          ScmDelay.INSTANCE);
    define ("denominator",                    new ScmNotImplemented ("denominator"));
    define ("display",                        ScmDisplay.INSTANCE);
    define ("do",                             ScmDo.INSTANCE);
    define ("eof-object?",                    ScmIsEOF.INSTANCE);
    define ("eq?",                            ScmIsEq.INSTANCE);
    define ("equal?",                         ScmIsEqual.INSTANCE);
    define ("eqv?",                           ScmIsEq.INSTANCE);
    define ("even?",                          ScmIsEven.INSTANCE);
    define ("exact?",                         ScmIsExact.INSTANCE);
    define ("exact->inexact",                 ScmExactToInexact.INSTANCE);
    define ("exp",                            ScmExp.INSTANCE);
    define ("expt",                           ScmExpt.INSTANCE);
    define ("floor",                          ScmFloor.INSTANCE);
    define ("force",                          ScmForce.INSTANCE);
    define ("for-each",                       ScmForEach.INSTANCE);
    define ("gcd",                            ScmGcd.INSTANCE);
    define ("if",                             ScmIf.INSTANCE);
    define ("imag-part",                      new ScmNotImplemented ("imag-part"));
    define ("inexact?",                       ScmIsInexact.INSTANCE);
    define ("inexact->exact",                 ScmInexactToExact.INSTANCE);
    define ("input-port?",                    ScmIsInputPort.INSTANCE);
    define ("integer?",                       ScmIsInteger.INSTANCE);
    define ("integer->char",                  ScmIntegerToChar.INSTANCE);
    define ("lambda",                         ScmLambda.INSTANCE);
    define ("lcm",                            ScmLcm.INSTANCE);
    define ("length",                         ScmLength.INSTANCE);
    define ("let",                            ScmLet.INSTANCE);
    define ("let*",                           ScmLetstar.INSTANCE);
    define ("letrec",                         ScmLetrec.INSTANCE);
    define ("list?",                          ScmIsList.INSTANCE);
    define ("list",                           ScmList.INSTANCE);
    define ("list-ref",                       ScmListRef.INSTANCE);
    define ("list-tail",                      ScmListTail.INSTANCE);
    define ("list->string",                   ScmListToString.INSTANCE);
    define ("list->vector",                   ScmListToVector.INSTANCE);
    define ("load",                           ScmLoad.INSTANCE);
    define ("log",                            ScmLog.INSTANCE);
    define ("magnitude",                      new ScmNotImplemented ("magnitude"));
    define ("make-polar",                     new ScmNotImplemented ("make-polar"));
    define ("make-rectangular",              new ScmNotImplemented ("make-rectangular"));
    define ("make-string",                    ScmMakeString.INSTANCE);
    define ("make-vector",                    ScmMakeVector.INSTANCE);
    define ("map",                            ScmMap.INSTANCE);
    define ("max",                            ScmMax.INSTANCE);
    define ("member",                         ScmMember.INSTANCE);
    define ("memq",                           ScmMemq.INSTANCE);
    define ("memv",                           ScmMemq.INSTANCE);
    define ("min",                            ScmMin.INSTANCE);
    define ("modulo",                         ScmModulo.INSTANCE);
    define ("negative?",                      ScmIsNegative.INSTANCE);
    define ("newline",                        ScmNewline.INSTANCE);
    define ("not",                            ScmNot.INSTANCE);
    define ("null?",                          ScmIsNull.INSTANCE);
    define ("number?",                        ScmIsNumber.INSTANCE);
    define ("number->string",                 ScmNumberToString.INSTANCE);
    define ("numerator",                      new ScmNotImplemented ("numerator"));
    define ("odd?",                           ScmIsOdd.INSTANCE);
    define ("open-input-file",                ScmOpenInputFile.INSTANCE);
    define ("open-output-file",               ScmOpenOutputFile.INSTANCE);
    define ("or",                             ScmOr.INSTANCE);
    define ("output-port?",                   ScmIsOutputPort.INSTANCE);
    define ("pair?",                          ScmIsPair.INSTANCE);
    define ("peek-char",                      ScmPeekChar.INSTANCE);
    define ("positive?",                      ScmIsPositive.INSTANCE);
    define ("procedure?",                     ScmIsProcedure.INSTANCE);
    define ("quasiquote",                     ScmQuasiquote.INSTANCE);
    define ("quote",                          ScmQuote.INSTANCE);
    define ("quotient",                       ScmQuotient.INSTANCE);
    define ("rational?",                      new ScmNotImplemented ("rational?"));
    define ("rationalize",                    new ScmNotImplemented ("rationalize"));
    define ("read",                           ScmRead.INSTANCE);
    define ("read-char",                      ScmReadChar.INSTANCE);
    define ("real?",                          ScmIsReal.INSTANCE);
    define ("real-part",                      new ScmNotImplemented ("real-part"));
    define ("remainder",                      ScmRemainder.INSTANCE);
    define ("reverse",                        ScmReverse.INSTANCE);
    define ("round",                          ScmRound.INSTANCE);
    define ("set!",                           ScmSetq.INSTANCE);
    define ("set-car!",                       ScmSetCar.INSTANCE);
    define ("set-cdr!",                       ScmSetCdr.INSTANCE);
    define ("sin",                            ScmSin.INSTANCE);
    define ("sqrt",                           ScmSqrt.INSTANCE);
    define ("string-append",                  ScmStringAppend.INSTANCE);
    define ("string?",                        ScmIsString.INSTANCE);
    define ("string=?",                       ScmIsStringEqual.INSTANCE);
    define ("string>?",                       ScmIsStringGreater.INSTANCE);
    define ("string<?",                       ScmIsStringLess.INSTANCE);
    define ("string>=?",                      ScmIsStringGreaterOrEqual.INSTANCE);
    define ("string<=?",                      ScmIsStringLessOrEqual.INSTANCE);
    define ("string-ci=?",                    ScmIsStringCIEqual.INSTANCE);
    define ("string-ci>?",                    ScmIsStringCIGreater.INSTANCE);
    define ("string-ci<?",                    ScmIsStringCILess.INSTANCE);
    define ("string-ci>=?",                   ScmIsStringCIGreaterOrEqual.INSTANCE);
    define ("string-ci<=?",                   ScmIsStringCILessOrEqual.INSTANCE);
    define ("string",                         ScmCharsToString.INSTANCE);
    define ("string-copy",                    ScmStringCopy.INSTANCE);
    define ("string-fill!",                   ScmStringFill.INSTANCE);
    define ("string-length",                  ScmStringLength.INSTANCE);
    define ("string->list",                   ScmStringToList.INSTANCE);
    define ("string-ref",                     ScmStringRef.INSTANCE);
    define ("string-set!",                    ScmStringSet.INSTANCE);
    define ("string->number",                 ScmStringToNumber.INSTANCE);
    define ("string->symbol",                 ScmStringToSymbol.INSTANCE);
    define ("substring",                      ScmSubstring.INSTANCE);
    define ("symbol?",                        ScmIsSymbol.INSTANCE);
    define ("symbol->string",                 ScmSymbolToString.INSTANCE);
    define ("tan",                            ScmTan.INSTANCE);
    define ("truncate",                       ScmTruncate.INSTANCE);
    define ("unquote",                        ScmUnquote.INSTANCE);
    define ("unquote-splicing",               ScmUnquoteSplicing.INSTANCE);
    define ("vector?",                        ScmIsVector.INSTANCE);
    define ("vector",                         ScmObjectsToVector.INSTANCE);
    define ("vector-fill!",                   ScmVectorFill.INSTANCE);
    define ("vector-length",                  ScmVectorLength.INSTANCE);
    define ("vector->list",                   ScmVectorToList.INSTANCE);
    define ("vector-ref",                     ScmVectorRef.INSTANCE);
    define ("vector-set!",                    ScmVectorSet.INSTANCE);
    define ("with-input-from-file",           ScmWithInputFromFile.INSTANCE);
    define ("with-output-to-file",            ScmWithOutputToFile.INSTANCE);
    define ("write",                          ScmWrite.INSTANCE);
    define ("write-char",                     ScmWriteChar.INSTANCE);
    define ("zero?",                          ScmIsZero.INSTANCE);
  }
}
