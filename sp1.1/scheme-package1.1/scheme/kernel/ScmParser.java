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

import java.io.*;
import java.util.*;

/**
 * Scheme language parser
 *
 * @author  Stephane Hillion
 * @version 1.0 - 1998/11/12
 */

public class ScmParser {
  // Private fields
  private ScmScanner scanner;
  private ScmToken current;

  /**
   * Creates a new parser
   * @param r the input stream reader
   */
  public ScmParser (Reader r) {
    scanner = new ScmScanner (r);
  }

  /**
   * Reads a scheme object
   * @return    the next object or null
   */
  public ScmObject read () throws ScmException {
    current = scanner.next ();
    return currentRead ();
  }

  /**
   * Reads a scheme object ('read' auxiliary method)
   */
  private ScmObject currentRead () throws ScmException {
    if (current == null) return null;

    switch (current.getType()) {
    case ScmToken.LBRA :
      return readPair ();

    case ScmToken.SYMBOL :
      return new ScmSymbol (current.getString());

    case ScmToken.INTEGER :
      return new ScmInteger (current.getString());

    case ScmToken.STRING :
      return new ScmString (current.getString());

    case ScmToken.TRUE :
      return ScmBoolean.T;

    case ScmToken.FALSE :
      return ScmBoolean.F;

    case ScmToken.REAL :
      return new ScmReal (current.getString());

    case ScmToken.QUOTE :
      return readQuote ();

    case ScmToken.VBRA :
      return readVector ();

    case ScmToken.CHAR :
      return new ScmChar (current.getString().charAt(0));

    case ScmToken.QUASIQUOTE :
      return readQuasiquote ();

    case ScmToken.UNQUOTE :
      return readUnquote ();

    case ScmToken.UNQUOTE_SPLICING :
      return readUnquoteSplicing ();

    default :
      throw new ScmException ("Unexpected lexem : "+current.getString());
    }
  }

  /**
   * Reads a quoted object
   */
  private ScmObject readQuote () throws ScmException {
    current = scanner.next ();

    if (current == null)
      throw new ScmException ("Unexpected end-of-file");

    return new ScmPair (ScmSymbol.QUOTE,
			new ScmPair (currentRead (), ScmPair.NULL));
  }

  /**
   * Reads a quasiquoted object
   */
  private ScmObject readQuasiquote () throws ScmException {
    current = scanner.next ();

    if (current == null)
      throw new ScmException ("Unexpected end-of-file");

    return new ScmPair (ScmSymbol.QUASIQUOTE,
			new ScmPair (currentRead (), ScmPair.NULL));
  }

  /**
   * Reads an unquoted object
   */
  private ScmObject readUnquote () throws ScmException {
    current = scanner.next ();

    if (current == null)
      throw new ScmException ("Unexpected end-of-file");

    return new ScmPair (ScmSymbol.UNQUOTE,
			new ScmPair (currentRead (), ScmPair.NULL));
  }

  /**
   * Reads an unquote-splicing object
   */
  private ScmObject readUnquoteSplicing () throws ScmException {
    current = scanner.next ();

    if (current == null)
      throw new ScmException ("Unexpected end-of-file");

    return new ScmPair (ScmSymbol.UNQUOTE_SPLICING,
			new ScmPair (currentRead (), ScmPair.NULL));
  }

  /**
   * Reads a pair
   */
  private ScmObject readPair () throws ScmException {
    current = scanner.next ();
    
    ScmPair result = ScmPair.NULL;
    ScmPair curs   = null;

    while (current != null && 
	   current.getType() != ScmToken.RBRA &&
	   current.getType() != ScmToken.DOT) {
      if (curs == null) {
	result = new ScmPair (currentRead(), result);
	curs   = result;
      } else {
	ScmPair tmp = new ScmPair (currentRead(), ScmPair.NULL);
	curs.setCdr (tmp);
	curs = tmp;
      }
      current = scanner.next ();
    }

    if (current == null)
      throw new ScmException ("Unexpected end-of-file");
    else if (current.getType() == ScmToken.DOT) {
      if (curs == null)
	throw new ScmException ("Unexpected '.'");

      current = scanner.next ();
      curs.setCdr (currentRead ());
      
      current = scanner.next ();
      if (current == null)
	throw new ScmException ("Unexpected end-of-file");
      else if (current.getType() != ScmToken.RBRA)
	throw new ScmException ("')' expected");   
    }

    return result;
  }
    
  /**
   * Reads a vector
   */
  private ScmObject readVector () throws ScmException {
    current = scanner.next ();

    ScmArray list = new ScmArray ();

    while (current != null && current.getType() != ScmToken.RBRA) {
      list.add (currentRead());
      current = scanner.next ();
    }

    if (current == null)
      throw new ScmException ("Unexpected end-of-file.");

    return new ScmVector (list);
  }
}
