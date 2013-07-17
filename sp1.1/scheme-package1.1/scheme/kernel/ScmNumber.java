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

/**
 * Scheme numbers
 *
 * @author  Stephane Hillion
 * @version 1.1 - 1998/12/10
 */
public abstract class ScmNumber extends ScmAtom {
  /**
   * Object structural equality
   *
   * @param      obj - The object to test
   * @return     true if this and obj have the same structure
   */
  public boolean isEqual (ScmObject obj) {
    if (this == obj)
      return true;

    if (getClass () == obj.getClass ())
      return atomEqual ((ScmAtom)obj);
    
    if (obj instanceof ScmNumber) {
      if (this instanceof ScmInteger) {
	return ((ScmInteger)this).getValue() == ((ScmReal)obj).getValue();
      } else {
	return ((ScmReal)this).getValue() == ((ScmInteger)obj).getValue();
      }
    }
    return false;
  }

  /**
   * Absolute value of this number
   */
  public abstract ScmNumber abs ();

  /**
   * arc cosinus of this number
   */
  public abstract ScmNumber acos () throws ScmException;

  /**
   * arc sinus of this number
   */
  public abstract ScmNumber asin () throws ScmException;

  /**
   * atan of this number
   */
  public abstract ScmNumber atan () throws ScmException;

  /**
   * 2 arguments atan
   */
  public abstract ScmNumber atan (ScmNumber other) throws ScmException;

  /**
   * The ceiling of this number
   */
  public abstract ScmNumber ceiling () throws ScmException;

  /**
   * The floor of this number
   */
  public abstract ScmNumber floor () throws ScmException;

  /**
   * The truncature of this number
   */
  public abstract ScmNumber truncate () throws ScmException;

  /**
   * The closest integer of this number
   */
  public abstract ScmNumber round () throws ScmException;

  /**
   * cosinus of this number
   */
  public abstract ScmNumber cos () throws ScmException;

  /**
   * sinus of this number
   */
  public abstract ScmNumber sin () throws ScmException;

  /**
   * tangent of this number
   */
  public abstract ScmNumber tan () throws ScmException;

  /**
   * Square root of this number
   */
  public abstract ScmNumber sqrt () throws ScmException;

  /**
   * exp function
   */
  public abstract ScmNumber exp () throws ScmException;

  /**
   * log function
   */
  public abstract ScmNumber log () throws ScmException;

  /**
   * expt function
   */
  public abstract ScmNumber expt (ScmNumber other) throws ScmException;

  /**
   * Addition of two numbers
   */
  public abstract ScmNumber add (ScmNumber obj);

  /**
   * Subtraction of two numbers
   */
  public abstract ScmNumber sub (ScmNumber obj);

  /**
   * Product of two numbers
   */
  public abstract ScmNumber mul (ScmNumber obj);

  /**
   * Division of two numbers
   */
  public abstract ScmNumber div (ScmNumber obj);

  /**
   * Quotient of two numbers
   */
  public abstract ScmNumber quotient (ScmNumber obj) throws ScmException;

  /**
   * Remainder of two numbers
   */
  public abstract ScmNumber remainder (ScmNumber obj) throws ScmException;

  /**
   * Modulo of two numbers
   */
  public abstract ScmNumber modulo (ScmNumber obj) throws ScmException;

  /**
   * GCD of two numbers
   */
  public abstract ScmNumber gcd (ScmNumber obj) throws ScmException;

  /**
   * Numbers comparison
   */
  public abstract boolean lessThan (ScmNumber obj);

  /**
   * Numbers comparison
   */
  public abstract boolean greaterThan (ScmNumber obj);

  /**
   * Numbers comparison
   */
  public abstract boolean lessOrEqualThan (ScmNumber obj);

  /**
   * Numbers comparison
   */
  public abstract boolean greaterOrEqualThan (ScmNumber obj);

}
