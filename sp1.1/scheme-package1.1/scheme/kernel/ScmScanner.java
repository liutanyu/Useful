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

/**
 * The lexical scanner of the Scheme system
 *
 * @author  Stephane Hillion
 * @version 1.2 - 1998/12/24
 */
public class ScmScanner {
  // Private members
  //
  private PushbackReader reader;
  private int            current;

  /**
   * Create a new scanner
   * @param r The character source
   */
  public ScmScanner (Reader r) {
    reader = new PushbackReader (r);
  }

  /**
   * Reads the next lexem
   */
  public ScmToken next () throws ScmException {
    try {
      current = reader.read ();
      eatSpaces ();

      if (current == -1) return null;

      if (current == '(')
	return ScmToken.LBra;

      if (current == ')')
	return ScmToken.RBra;

      if (current == '\'')
	return ScmToken.Quote;

      if (Character.isDigit ((char)current))
	return readNumber ("");
    
      if (current == '"') {
	current = reader.read ();
	return readString ();
      }

      if (current == '.') {
	current = reader.read ();

	if (isSeparator()) {
	  reader.unread (current);
	  return ScmToken.Dot;
	}
	else
	  return readIdent (".");
      }

      if (current == '#') {
	current = reader.read ();
      
	if (current == '(')
	  return ScmToken.VBra;
      
	if (current == 't') {
	  current = reader.read ();

	  if (current == -1 || isSeparator ()) {
	    reader.unread (current);
	    return ScmToken.True;
	  }
	  else
	    return readIdent ("#t");
	}
  
	if (current == 'f') {
	  current = reader.read ();
	      
	  if (current == -1 || isSeparator ())
	    {
	      reader.unread (current);
	      return ScmToken.False;
	    }
	  else
	    return readIdent ("#f");
	}

	if (current == '\\') {
	  current = reader.read ();
	  return readScmChar ();
	}

	return readIdent ("#");
      }

      if (current == '-') {
	current = reader.read ();
	return readNumber ("-");
      }

      if (current == '+') {
	current = reader.read ();
	return readNumber ("");
      }

      if (current == '`')
	return ScmToken.Quasiquote;

      if (current == ',') {
	current = reader.read ();
	  
	if (current == '@')
	  return ScmToken.UnquoteSplicing;
	else {
	  reader.unread (current);
	  return ScmToken.Unquote;
	}
      }

      return readIdent ("");
    }
    catch (IOException e) {
      throw new ScmException (e.toString());
    }
  }

  /**
   * Eats spaces and comments
   */
  private void eatSpaces () throws IOException {
    while (current != -1 &&
           (current == ' '  ||
	    current == '\t' ||
	    current == '\n' ||
	    current == 13   ||
	    current == ';')) {
      if (current == ';')
	while (current != -1 && current != '\n')
	  current = reader.read ();

      if (current == -1)
	break;
      current = reader.read ();
    }
  }

  /**
   * Reads a literal string
   */
  private ScmToken readString () throws ScmException, IOException {
    String result = "";

    while (current != -1 && current != '"') {
      if (current == '\\')
	while (current == '\\') {
	  current = reader.read ();

	  if (current == -1)
	    throw new ScmException ("Unexpected end-of-file");

	  if (current != 13)
	      result = result + (char)current;
	  current = reader.read ();
	}
      else {
	if (current != 13)
	  result = result + (char)current;
	current = reader.read ();
      }
    }

    if (current == -1)
      throw new ScmException ("Unexpected end-of-file");

    return new ScmToken (ScmToken.STRING, result);
  }

  /**
   * Reads an identifier 
   */
  private ScmToken readIdent (String prefix) throws IOException {
    String result = prefix;

    while (current != -1 && !isSeparator()) {
      result = result + (char)current;
      current = reader.read ();
    }

    reader.unread (current);
    return new ScmToken (ScmToken.SYMBOL, result);
  }

  /**
   * Is the current character a separator
   */
  private boolean isSeparator() {
    return current == '('  ||
           current == ')'  ||
           current == '\'' ||
           current == '`' ||
           current == '\n' ||
           current == '\t' ||
           current == 13   ||
           current == ';'  ||
           current == ' ';
  }

  /**
   * Reads a literal number
   */
  private ScmToken readNumber (String prefix) throws IOException {
    String result = prefix;

    if (isSeparator())
      if (prefix.equals("-"))
	return readIdent ("-");
      else
	return readIdent ("+");

    while (current >= '0' && current <= '9') {
      result = result + (char)current;
      current = reader.read ();
    }

    if (current == '.') {
      result  = result + (char)current;
      current = reader.read ();
      return readReal (result);
    }

    if (Character.toLowerCase ((char)current) == 'e') {
      result  = result + 'e';
      current = reader.read ();
      return readReal2 (result);
    }

    if (isSeparator()) {
      reader.unread (current);
      return new ScmToken (ScmToken.INTEGER, result);
    }
    else
      return readIdent (result);
  }

  /**
   * Reads a real number
   */
  private ScmToken readReal (String prefix) throws IOException {
    String result = prefix;

    while (current >= '0' && current <= '9') {
      result = result + (char)current;
      current = reader.read ();
    }

    if (Character.toLowerCase ((char)current) == 'e') {
      result  = result + 'e';
      current = reader.read ();
      return readReal2 (result);
    }    

    if (isSeparator()) {
      reader.unread (current);
      return new ScmToken (ScmToken.REAL, result);
    }
    else
      return readIdent (result);
  }

  /**
   * Reads a real number (auxiliary method)
   */
  private ScmToken readReal2 (String prefix) throws IOException {
    String result = prefix;

    if (current == '+' || current == '-') {
      result  = result + (char)current;
      current = reader.read ();
    }    

    if (!Character.isDigit ((char)current))
      return readIdent (result);

    while (current >= '0' && current <= '9') {
      result = result + (char)current;
      current = reader.read ();
    }

    if (isSeparator()) {
      reader.unread (current);
      return new ScmToken (ScmToken.REAL, result);
    }
    else
      return readIdent (result);
  }

  /**
   * Reads a character
   */
  private ScmToken readScmChar () throws ScmException, IOException {
    String rep = "";

    if (current == ' ')
      return new ScmToken (ScmToken.CHAR, " ");

    if (current == ';')
      return new ScmToken (ScmToken.CHAR, ";");

    if (current == '(')
      return new ScmToken (ScmToken.CHAR, "(");

    if (current == ')')
      return new ScmToken (ScmToken.CHAR, ")");

    if (current == '\'')
      return new ScmToken (ScmToken.CHAR, "'");

    if (current == '`')
      return new ScmToken (ScmToken.CHAR, "`");

    while (current != -1 && !isSeparator()) {
      rep = rep + (char)current;
      current = reader.read ();
    }

    reader.unread (current);

    if (rep.length() == 1)
      return new ScmToken (ScmToken.CHAR, rep);
    
    if (rep.equalsIgnoreCase ("null"))
      return new ScmToken (ScmToken.CHAR, String.valueOf((char)0));

    if (rep.equalsIgnoreCase ("soh"))
      return new ScmToken (ScmToken.CHAR, String.valueOf((char)1));

    if (rep.equalsIgnoreCase ("stx"))
      return new ScmToken (ScmToken.CHAR, String.valueOf((char)2));

    if (rep.equalsIgnoreCase ("etx"))
      return new ScmToken (ScmToken.CHAR, String.valueOf((char)3));

    if (rep.equalsIgnoreCase ("eot"))
      return new ScmToken (ScmToken.CHAR, String.valueOf((char)4));

    if (rep.equalsIgnoreCase ("enq"))
      return new ScmToken (ScmToken.CHAR, String.valueOf((char)5));

    if (rep.equalsIgnoreCase ("ack"))
      return new ScmToken (ScmToken.CHAR, String.valueOf((char)6));

    if (rep.equalsIgnoreCase ("bell"))
      return new ScmToken (ScmToken.CHAR, String.valueOf((char)7));

    if (rep.equalsIgnoreCase ("backspace"))
      return new ScmToken (ScmToken.CHAR, String.valueOf((char)8));

    if (rep.equalsIgnoreCase ("ht"))
      return new ScmToken (ScmToken.CHAR, String.valueOf((char)9));

    if (rep.equalsIgnoreCase ("newline"))
      return new ScmToken (ScmToken.CHAR, String.valueOf((char)10));

    if (rep.equalsIgnoreCase ("vt"))
      return new ScmToken (ScmToken.CHAR, String.valueOf((char)11));

    if (rep.equalsIgnoreCase ("page"))
      return new ScmToken (ScmToken.CHAR, String.valueOf((char)12));

    if (rep.equalsIgnoreCase ("return"))
      return new ScmToken (ScmToken.CHAR, String.valueOf((char)13));

    if (rep.equalsIgnoreCase ("so"))
      return new ScmToken (ScmToken.CHAR, String.valueOf((char)14));

    if (rep.equalsIgnoreCase ("si"))
      return new ScmToken (ScmToken.CHAR, String.valueOf((char)15));

    if (rep.equalsIgnoreCase ("dle"))
      return new ScmToken (ScmToken.CHAR, String.valueOf((char)16));

    if (rep.equalsIgnoreCase ("dc1"))
      return new ScmToken (ScmToken.CHAR, String.valueOf((char)17));

    if (rep.equalsIgnoreCase ("dc2"))
      return new ScmToken (ScmToken.CHAR, String.valueOf((char)18));

    if (rep.equalsIgnoreCase ("dc3"))
      return new ScmToken (ScmToken.CHAR, String.valueOf((char)19));

    if (rep.equalsIgnoreCase ("dc4"))
      return new ScmToken (ScmToken.CHAR, String.valueOf((char)20));

    if (rep.equalsIgnoreCase ("nak"))
      return new ScmToken (ScmToken.CHAR, String.valueOf((char)21));

    if (rep.equalsIgnoreCase ("syn"))
      return new ScmToken (ScmToken.CHAR, String.valueOf((char)22));

    if (rep.equalsIgnoreCase ("etb"))
      return new ScmToken (ScmToken.CHAR, String.valueOf((char)23));

    if (rep.equalsIgnoreCase ("can"))
      return new ScmToken (ScmToken.CHAR, String.valueOf((char)24));

    if (rep.equalsIgnoreCase ("em"))
      return new ScmToken (ScmToken.CHAR, String.valueOf((char)25));

    if (rep.equalsIgnoreCase ("sub"))
      return new ScmToken (ScmToken.CHAR, String.valueOf((char)26));

    if (rep.equalsIgnoreCase ("escape"))
      return new ScmToken (ScmToken.CHAR, String.valueOf((char)27));

    if (rep.equalsIgnoreCase ("fs"))
      return new ScmToken (ScmToken.CHAR, String.valueOf((char)28));

    if (rep.equalsIgnoreCase ("gs"))
      return new ScmToken (ScmToken.CHAR, String.valueOf((char)29));

    if (rep.equalsIgnoreCase ("rs"))
      return new ScmToken (ScmToken.CHAR, String.valueOf((char)30));

    if (rep.equalsIgnoreCase ("us"))
      return new ScmToken (ScmToken.CHAR, String.valueOf((char)31));

    if (rep.equalsIgnoreCase ("space"))
      return new ScmToken (ScmToken.CHAR, String.valueOf((char)32));

    else
      throw new ScmException ("read : Not a valid char : "+rep);
  }
}
