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
 * The Scheme language pair
 *
 * @author  Stephane Hillion
 * @version 1.1 - 1998/12/10
 */
public class ScmPair extends ScmObject {
  /** car implementation */
  private ScmObject car;
  /** cdr implementation */
  private ScmObject cdr;

  /**
   * The null pair
   */
  public final static ScmPair NULL = new ScmPair ();

  /**
   * Creates a new pair
   * @param car - The first element of the pair
   * @param cdr - The second element of the pair
   */
  public ScmPair (ScmObject car, ScmObject cdr) {
    this.car = car;
    this.cdr = cdr;
  }

  /**
   * Creates a null pair
   */
  protected ScmPair () {
    car = null;
    cdr = null;
  }

  /**
   * Object structural equality
   * @param      obj - The object to test
   * @return     true if this and obj have the same structure
   */
  public boolean isEqual (ScmObject obj) {
    if (this == obj)
      return true;

    if (getClass() != obj.getClass())
      return false;

    return car.isEqual (((ScmPair)obj).car) &&
           cdr.isEqual (((ScmPair)obj).cdr);
  }

  /**
   * Returns the car
   * @return the first element of this pair
   */
  public ScmObject getCar () {
    return car;
  }

  /**
   * Changes the value of the first element of this pair
   * @param v - The new value
   */
  public void setCar (ScmObject v) {
    car = v;
  }

  /**
   * Returns the cdr
   * @return the second element of this pair
   */
  public ScmObject getCdr () {
    return cdr;
  }

  /**
   * Changes the value of the second element of this pair
   * @param v - The new value
   * @require v != null
   */
  public void setCdr (ScmObject v) {
    cdr = v;
  }

  /**
   * @return the external representation of this pair
   */
  public String toString ()
  {
    if (this == NULL)
      return "()";
    
    String    res = "(" + car.toString();
    ScmObject tmp = cdr;

    // Removes '. ( ... )'
    //
    while ((tmp != NULL) && (tmp instanceof ScmPair)) {
      res = res + " " + ((ScmPair)tmp).car.toString();
      tmp = ((ScmPair)tmp).cdr;
    }

    if (tmp == NULL)
      return res + ")";
    
    return res + " . " + tmp.toString() + ")";
  }

  /**
   * External representation of this object
   */
  public String toDisplayString () {
    if (this == NULL)
      return "()";
    
    String    res = "(" + car.toDisplayString();
    ScmObject tmp = cdr;

    // Removes '. ( ... )'
    //
    while ((tmp != NULL) && (tmp instanceof ScmPair)) {
      res = res + " " + ((ScmPair)tmp).car.toDisplayString();
      tmp = ((ScmPair)tmp).cdr;
    }

    if (tmp == NULL)
      return res + ")";
    
    return res + " . " + tmp.toDisplayString() + ")";
  }
}
