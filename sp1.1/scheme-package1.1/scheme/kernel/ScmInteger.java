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
 * Scheme language (small) integers
 *
 * @author  Stephane Hillion
 * @version 1.1 - 1998/12/10
 */
public class ScmInteger extends ScmNumber {
  /** The implementation */
  protected int value;

  /** Zero */
  public final static ScmInteger ZERO = new ScmInteger (0);

  /** One */
  public final static ScmInteger ONE = new ScmInteger (1);

  /**
   * Creates a new integer represented by str
   * @param str The representation of this symbol
   */
  public ScmInteger (String str) throws ScmException {
    try {
      value = Integer.parseInt (str);
    } catch (NumberFormatException e) {
      throw new ScmException ("Bad integer: "+str);
    }
  }

  /**
   * Creates a new integer initialized to i
   * @param i The initial value
   */
  public ScmInteger (int i) {
    value = i;
  }

  /**
   * Reads the value of this integer
   */
  public int getValue() {
    return value;
  }

  /**
   * The external representation of this object
   */
  public String toString () {
    return Integer.toString (value);
  }

  /**
   * Absolute value of this number
   */
  public ScmNumber abs () {
    return new ScmInteger (Math.abs (value));
  }

  /**
   * arc cosinus of this number
   */
  public ScmNumber acos () throws ScmException {
    if (value < -1 || value > 1)
      error ("Value out of range: "+value);

    return new ScmReal (Math.acos (value));
  }

  /**
   * arc sinus of this number
   */
  public ScmNumber asin () throws ScmException {
    if (value < -1 || value > 1)
      error ("Value out of range: "+value);

    return new ScmReal (Math.asin (value));
  }

  /**
   * atan of this number
   */
  public ScmNumber atan () throws ScmException {
    return new ScmReal (Math.atan (value));
  }

  /**
   * 2 arguments atan
   */
  public ScmNumber atan (ScmNumber other) throws ScmException {
    if (other instanceof ScmInteger)
      return new ScmReal (Math.atan2 (value, ((ScmInteger)other).value));
    else
      return new ScmReal (Math.atan2 (value, ((ScmReal)other).value));
  }

  /**
   * The ceiling of this number
   */
  public ScmNumber ceiling () throws ScmException {
    return this;
  }

  /**
   * The floor of this number
   */
  public ScmNumber floor () throws ScmException {
    return this;
  }

  /**
   * The truncature of this number
   */
  public ScmNumber truncate () throws ScmException {
    return this;
  }

  /**
   * The closest integer of this number
   */
  public ScmNumber round () throws ScmException {
    return this;
  }

  /**
   * cosinus of this number
   */
  public ScmNumber cos () throws ScmException {
    return new ScmReal (Math.cos (value));
  }

  /**
   * sinus of this number
   */
  public ScmNumber sin () throws ScmException {
    return new ScmReal (Math.sin (value));
  }

  /**
   * tangent of this number
   */
  public ScmNumber tan () throws ScmException {
    return new ScmReal (Math.tan (value));
  }

  /**
   * Square root of this number
   */
  public ScmNumber sqrt () throws ScmException {
    if (value < 0)
      error ("Value out of range: "+value);

    double res = Math.sqrt (value);
    if (res == (int)res)
      return new ScmInteger ((int)res);
    else
      return new ScmReal (res);
  }

  /**
   * exp function
   */
  public ScmNumber exp () throws ScmException {
    return new ScmReal (Math.exp (value));    
  }

  /**
   * log function
   */
  public ScmNumber log () throws ScmException {
    if (value <= 0)
      error ("Value out of range: "+value);
    return new ScmReal (Math.log (value));
  }

  /**
   * expt function
   */
  public ScmNumber expt (ScmNumber other) throws ScmException {
    if (other instanceof ScmInteger)
      return new ScmReal (Math.pow (value, ((ScmInteger)other).value));
    else
      return new ScmReal (Math.pow (value, ((ScmReal)other).value));
  }

  /**
   * gcd function
   */
  public ScmNumber gcd (ScmNumber other) throws ScmException {
    if (other instanceof ScmInteger) {
      int r = value;
      int v = ((ScmInteger)other).value;
      int t;

      while (v != 0) {
	t = v;
	v = r % v;
	r = t;
      }

      return new ScmInteger (Math.abs (r));
    } else {
      double d = ((ScmReal)other).value;

      if (d != (int)d)
	error ("Invalid parameter: "+d);

      int r = value;
      int v = (int)d;
      int t;

      while (v != 0) {
	t = v;
	v = r % v;
	r = t;
      }

      return new ScmReal (Math.abs (r));
    }
  }

  /**
   * Addition of two numbers
   */
  public ScmNumber add (ScmNumber obj) {
    if (obj instanceof ScmInteger) {
      double d = (double)value + ((ScmInteger)obj).value;
      if (d == (int)d)
	return new ScmInteger ((int)d);
      else
	return new ScmReal (d);
    } else {
      double d = (double)value + ((ScmReal)obj).value;
      if (d == (int)d)
	return new ScmInteger ((int)d);
      else
	return new ScmReal (d);
    }
  }

  /**
   * Subtraction of two numbers
   */
  public ScmNumber sub (ScmNumber obj) {
    if (obj instanceof ScmInteger) {
      double d = (double)value - ((ScmInteger)obj).value;
      if (d == (int)d)
	return new ScmInteger ((int)d);
      else
	return new ScmReal (d);
    } else {
      double d = (double)value - ((ScmReal)obj).value;
      if (d == (int)d)
	return new ScmInteger ((int)d);
      else
	return new ScmReal (d);
    }
  }

  /**
   * Product of two numbers
   */
  public ScmNumber mul (ScmNumber obj) {
    if (obj instanceof ScmInteger) {
      double d = (double)value * ((ScmInteger)obj).value;
      if (d == (int)d)
	return new ScmInteger ((int)d);
      else
	return new ScmReal (d);
    } else {
      double d = (double)value * ((ScmReal)obj).value;
      if (d == (int)d)
	return new ScmInteger ((int)d);
      else
	return new ScmReal (d);
    }
  }

  /**
   * Division of two numbers
   */
  public ScmNumber div (ScmNumber obj) {
    if (obj instanceof ScmInteger) {
      double d = (double)value / ((ScmInteger)obj).value;
      if (d == (int)d)
	return new ScmInteger ((int)d);
      else
	return new ScmReal (d);
    } else {
      double d = (double)value / ((ScmReal)obj).value;
      if (d == (int)d)
	return new ScmInteger ((int)d);
      else
	return new ScmReal (d);
    }
  }

  /**
   * Quotient of two numbers
   */
  public ScmNumber quotient (ScmNumber obj) throws ScmException {
    if (obj.isEqual (ZERO))
      error ("Division by 0");

    if (obj instanceof ScmInteger) {
      return new ScmInteger (value / ((ScmInteger)obj).value);
    } else {
      ScmReal x = (ScmReal)obj;
      if (x.value != (int)x.value)
	error ("Integer value expected: "+x);
      return new ScmReal (value / (int)x.value);
    }
  }

  /**
   * Remainder of two numbers
   */
  public ScmNumber remainder (ScmNumber obj) throws ScmException {
    if (obj.isEqual (ZERO))
      error ("Division by 0");

    int sgn = (value<0)?-1:1;

    if (obj instanceof ScmInteger) {
      return new ScmInteger (sgn * Math.abs(value % ((ScmInteger)obj).value));
    } else {
      ScmReal x = (ScmReal)obj;
      if (x.value != (int)x.value)
	error ("Integer value expected: "+x);
      return new ScmReal (sgn * Math.abs(value % (int)x.value));
    }
  }

  /**
   * Modulo of two numbers
   */
  public ScmNumber modulo (ScmNumber obj) throws ScmException {
    if (obj.isEqual (ZERO))
      error ("Division by 0");

    if (obj instanceof ScmInteger) {
      ScmInteger n = (ScmInteger)obj;
      if ((value > 0 && n.value < 0) ||
	  (value < 0 && n.value > 0))
	return new ScmInteger (n.value + value % n.value);
      else
	return new ScmInteger (value % n.value);
    } else {
      ScmReal x = (ScmReal)obj;
      if (x.value != (int)x.value)
	error ("Integer value expected: "+x);

      if ((value > 0 && x.value < 0) ||
	  (value < 0 && x.value > 0))
	return new ScmReal (x.value + value % (int)x.value);
      else
	return new ScmReal (value % (int)x.value);
    }
  }

  /**
   * Numbers comparison
   */
  public boolean lessThan (ScmNumber obj) {
    if (obj instanceof ScmInteger)
      return value < ((ScmInteger)obj).value;
    else
      return value < ((ScmReal)obj).value;
  }

  /**
   * Numbers comparison
   */
  public boolean greaterThan (ScmNumber obj) {
    if (obj instanceof ScmInteger)
      return value > ((ScmInteger)obj).value;
    else
      return value > ((ScmReal)obj).value;
  }

  /**
   * Numbers comparison
   */
  public boolean lessOrEqualThan (ScmNumber obj) {
    if (obj instanceof ScmInteger)
      return value <= ((ScmInteger)obj).value;
    else
      return value <= ((ScmReal)obj).value;
  }

  /**
   * Numbers comparison
   */
  public boolean greaterOrEqualThan (ScmNumber obj) {
    if (obj instanceof ScmInteger)
      return value >= ((ScmInteger)obj).value;
    else
      return value >= ((ScmReal)obj).value;
  }

  /**
   * Equality of two integers
   */
  protected boolean atomEqual (ScmAtom other) {
    return value == ((ScmInteger)other).value;
  }
}
