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
package scheme.extensions;

import scheme.kernel.*;

/**
 * A kernel with r4rs standard functions and some extensions
 * defined in the global environment
 *
 * @author  Stephane Hillion
 * @version 1.1 - 1998/12/10
 */
public class ScmExtendedKernel extends ScmStandardKernel {
    /**
     * Create a new kernel
     */
    public ScmExtendedKernel () {
	define ("*java-kernel*",                     new ScmJavaObject (this));
	define ("*java-null*",                       ScmJavaObject.NULL);
	define ("<class>",                           OScmClass.CLASS);
	define ("<object>",                          OScmClass.OBJECT);

	define ("assert",                            ScmAssert.INSTANCE);
	define ("autoload",                          ScmCreateAutoload.INSTANCE);
	define ("bit-and",                           ScmBitAnd.INSTANCE);
	define ("bit-lsh",                           ScmBitLsh.INSTANCE);
	define ("bit-not",                           ScmBitNot.INSTANCE);
	define ("bit-or",                            ScmBitOr.INSTANCE);
	define ("bit-rsh",                           ScmBitRsh.INSTANCE);
	define ("bit-xor",                           ScmBitXor.INSTANCE);
	define ("bound?",                            ScmIsBound.INSTANCE);
	define ("boolean->java-boolean",             ScmBooleanToJavaBoolean.INSTANCE);
	define ("char->java-char",                   ScmCharToJavaChar.INSTANCE);
	define ("call-with-input-string",            ScmCallWithInputString.INSTANCE);
	define ("call-with-output-string",           ScmCallWithOutputString.INSTANCE);
	define ("debug-off",                         ScmDebugOff.INSTANCE);
	define ("debug-on",                          ScmDebugOn.INSTANCE);
	define ("eval",                              ScmEval.INSTANCE);
	define ("exit",                              ScmExit.INSTANCE);
	define ("get-output-string",                 ScmGetOutputString.INSTANCE);
	define ("file-exists?",                      ScmIsFileExists.INSTANCE);
	define ("integer->java-byte",                ScmIntegerToJavaByte.INSTANCE);
	define ("integer->java-int",                 ScmIntegerToJavaInt.INSTANCE);
	define ("integer->java-long",                ScmIntegerToJavaLong.INSTANCE);
	define ("integer->java-short",               ScmIntegerToJavaShort.INSTANCE);
	define ("java-boolean->boolean",             ScmJavaBooleanToBoolean.INSTANCE);
	define ("java-byte->integer",                ScmJavaByteToInteger.INSTANCE);
	define ("java-char->char",                   ScmJavaCharToChar.INSTANCE);
	define ("java-class",                        ScmJavaClass.INSTANCE);
	define ("java-constructor",                  ScmJavaConstructor.INSTANCE);
	define ("java-double->real",                 ScmJavaDoubleToReal.INSTANCE);
	define ("java-field",                        ScmJavaField.INSTANCE);
	define ("java-field-get",                    ScmJavaFieldGet.INSTANCE);
	define ("java-field-set",                    ScmJavaFieldSet.INSTANCE);
	define ("java-float->real",                  ScmJavaFloatToReal.INSTANCE);
	define ("java-int->integer",                 ScmJavaIntToInteger.INSTANCE);
	define ("java-long->integer",                ScmJavaLongToInteger.INSTANCE);
	define ("java-method",                       ScmJavaMethod.INSTANCE);
	define ("java-method-invoke",                ScmJavaMethodInvoke.INSTANCE);
	define ("java-new-instance",                 ScmJavaNewInstance.INSTANCE);
	define ("java-object?",                      ScmIsJavaObject.INSTANCE);
	define ("java-object",                       ScmMakeJavaObject.INSTANCE);
	define ("java-short->integer",               ScmJavaShortToInteger.INSTANCE);
	define ("java-string->string",               ScmJavaStringToString.INSTANCE);
	define ("local-eval",                        ScmLocalEval.INSTANCE);
	define ("method?",                           OScmIsMethod.INSTANCE);
	define ("method",                            OScmDefineMethod.INSTANCE);
	define ("object?",                           OScmIsObject.INSTANCE);
	define ("open-input-string",                 ScmOpenInputString.INSTANCE);
	define ("open-output-string",                ScmOpenOutputString.INSTANCE);
	define ("output-string-port?",               ScmIsOutputStringPort.INSTANCE);
	define ("promise?",                          ScmIsPromise.INSTANCE);
	define ("random",                            ScmRandom.INSTANCE);
	define ("real->java-double",                 ScmRealToJavaDouble.INSTANCE);
	define ("real->java-float",                  ScmRealToJavaFloat.INSTANCE);
	define ("string->java-string",               ScmStringToJavaString.INSTANCE);
	define ("syntax?",                           ScmIsSyntax.INSTANCE);
	define ("syntax",                            ScmPSyntax.INSTANCE);
	define ("syntax-method",                     OScmDefineSyntacticMethod.INSTANCE);
	define ("time",                              ScmTime.INSTANCE);
	define ("with-input-from-string",            ScmWithInputFromString.INSTANCE);
	define ("with-output-to-string",             ScmWithOutputToString.INSTANCE);
    }
}
