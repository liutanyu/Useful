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
 * All scheme objects must have <code>ScmObject</code> as superclass.
 *
 * @author  Stephane Hillion
 * @version 1.0 - 1998/11/09
 */
public abstract class ScmObject {
  /**
   * Scheme object equality <code>eq?</code>
   *
   * @param      obj The object to test
   * @return     true if this and obj are references to the same object
   */
  public boolean isEq (ScmObject obj) {
    return this == obj;
  }

  /**
   * Scheme object structural equality <code>equal?</code>
   *
   * @param      obj The object to test
   * @return     true if this and obj have the same structure
   */
  public abstract boolean isEqual (ScmObject obj);

  /**
   * Raises an error
   * @param message A message explaining the error
   */
  protected void error (String message) throws ScmException {
    throw new ScmException ((this == ScmUndefined.UNDEFINED?
			    "#[eval]":toString())+": "+message);
  }

  /**
   * The external representation of this object
   * @return a string
   */
  public String toDisplayString () {
    return toString ();
  }

  /**
   * Casts the given object in a <code>ScmBoolean</code>
   * @param  obj a <code>ScmBoolean</code> or an error occurs
   * @return obj
   */
  protected ScmBoolean toBoolean (Object obj) throws ScmException {
    if (!(obj instanceof ScmBoolean))
      error ("Boolean expected: "+obj);
    return (ScmBoolean)obj;
  }

  /**
   * Casts the given object in a <code>ScmNumber</code>
   * @param  obj a <code>ScmNumber</code> or an error occurs
   * @return obj
   */
  protected ScmNumber toNumber (Object obj) throws ScmException {
    if (!(obj instanceof ScmNumber))
      error ("Number expected: "+obj);
    return (ScmNumber)obj;
  }

  /**
   * Casts the given object in a <code>ScmPair</code>
   * @param  obj a <code>ScmPair</code> or an error occurs
   * @return obj
   */
  protected ScmPair toPair (Object obj) throws ScmException {
    if (!(obj instanceof ScmPair))
      error ("Pair expected: "+obj);
    return (ScmPair)obj;
  }

  /**
   * Casts the given object in a <code>ScmPair</code>. The
   * object must not be <code>ScmPair.NULL</code>.
   * @param  obj a non null <code>ScmPair</code> or an error occurs
   * @return obj
   */
  protected ScmPair toNonNullPair (Object obj) throws ScmException {
    if (!(obj instanceof ScmPair) || obj == ScmPair.NULL)
      error ("Non null pair expected: "+obj);
    return (ScmPair)obj;
  }

  /**
   * Casts the given object in a <code>ScmSymbol</code>
   * @param  obj a <code>ScmSymbol</code> or an error occurs
   * @return obj
   */
  protected ScmSymbol toSymbol (Object obj) throws ScmException {
    if (!(obj instanceof ScmSymbol))
      error ("Symbol expected: "+obj);
    return (ScmSymbol)obj;
  }

  /**
   * Casts the given object in a <code>ScmProcedure</code>
   * @param  obj a <code>ScmProcedure</code> or an error occurs
   * @return obj
   */
  protected ScmProcedure toProcedure (Object obj) throws ScmException {
    if (!(obj instanceof ScmProcedure))
      error ("Procedure expected: "+obj);
    return (ScmProcedure)obj;
  }

  /**
   * Casts the given object in a <code>ScmPromise</code>
   * @param  obj a <code>ScmPromise</code> or an error occurs
   * @return obj
   */
  protected ScmPromise toPromise (Object obj) throws ScmException {
    if (!(obj instanceof ScmPromise))
      error ("Promise expected: "+obj);
    return (ScmPromise)obj;
  }

  /**
   * Casts the given object in a <code>ScmInputPort</code>
   * @param  obj a <code>ScmInputPort</code> or an error occurs
   * @return obj
   */
  protected ScmInputPort toInputPort (Object obj) throws ScmException {
    if (!(obj instanceof ScmInputPort))
      error ("Input port expected: "+obj);
    return (ScmInputPort)obj;
  }

  /**
   * Casts the given object in a <code>ScmOutputPort</code>
   * @param  obj a <code>ScmOutputPort</code> or an error occurs
   * @return obj
   */
  protected ScmOutputPort toOutputPort (Object obj) throws ScmException {
    if (!(obj instanceof ScmOutputPort))
      error ("Output port expected: "+obj);
    return (ScmOutputPort)obj;
  }

  /**
   * Casts the given object in a <code>ScmChar</code>
   * @param  obj a <code>ScmChar</code> or an error occurs
   * @return obj
   */
  protected ScmChar toChar (Object obj) throws ScmException {
    if (!(obj instanceof ScmChar))
      error ("Char expected: "+obj);
    return (ScmChar)obj;
  }

  /**
   * Casts the given object in a <code>ScmInteger</code>
   * @param  obj a <code>ScmInteger</code> or an error occurs
   * @return obj
   */
  protected ScmInteger toInteger (Object obj) throws ScmException {
    if (!(obj instanceof ScmInteger))
      error ("Integer expected: "+obj);
    return (ScmInteger)obj;
  }

  /**
   * Casts the given object in a <code>ScmReal</code>
   * @param  obj a <code>ScmReal</code> or an error occurs
   * @return obj
   */
  protected ScmReal toReal (Object obj) throws ScmException {
    if (!(obj instanceof ScmReal))
      error ("Real expected: "+obj);
    return (ScmReal)obj;
  }

  /**
   * Casts the given object in a <code>ScmVector</code>
   * @param  obj a <code>ScmVector</code> or an error occurs
   * @return obj
   */
  protected ScmVector toVector (Object obj) throws ScmException {
    if (!(obj instanceof ScmVector))
      error ("Vector expected: "+obj);
    return (ScmVector)obj;
  }

  /**
   * Casts the given object in a <code>ScmScmString</code>
   * @param  obj a <code>ScmScmString</code> or an error occurs
   * @return obj
   */
  protected ScmString toScmString (Object obj) throws ScmException {
    if (!(obj instanceof ScmString))
      error ("String expected: "+obj);
    return (ScmString)obj;
  }
}
