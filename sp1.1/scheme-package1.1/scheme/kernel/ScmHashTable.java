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
 * A hash table designed for this package.
 * It is an unsynchronized version of <code>java.util.Hashtable</code>.
 * Only <code>put</code> and <code>get</code> are implemented.
 *
 * @author  Stephane Hillion
 * @version 1.1 - 1998/12/23
 */

public class ScmHashTable {
  /** The table */
  private Entry [] table;

  /** The number of entries */
  private int count;

  /** The threshold */
  private int threshold;

  /** The loading factor */
  private final static float LF = 0.75f;
  
  /** The initial capacity */
  private final static int   IC = 11;

  /**
   * Creates a new hash table.
   */
  public ScmHashTable () {
    table     = new Entry [IC];
    count     = 0;
    threshold = (int)(IC * LF);
  }

  /**
   * Creates a new hash table.
   * @param ic the initial capacity
   */
  public ScmHashTable (int ic) {
    table     = new Entry [ic];
    count     = 0;
    threshold = (int)(IC * LF);
  }

  /**
   * Gets an item in the hash table
   * @param key the key to find
   */
  public ScmObject get (ScmSymbol key) {
    int hash  = key.hashCode() & 0x7FFFFFFF;
    int index = hash % table.length;

    for (Entry e = table [index]; e != null; e = e.next)
      if ((e.hash == hash) && e.key.equals (key))
	return e.value;
    return null;
  }

  /**
   * Puts a new value in the table
   * @param key   the key of the mapping
   * @param value the value to map with <code>key</code>
   */
  public ScmObject put (ScmSymbol key, ScmObject value) {
    int hash  = key.hashCode() & 0x7FFFFFFF;
    int index = hash % table.length;

    for (Entry e = table [index]; e != null; e = e.next)
      if ((e.hash == hash) && e.key.equals (key)) {
	ScmObject old = e.value;
	e.value = value;
	return old;
      }
    // The key is not in the hash table

    if (count++ >= threshold) {
      rehash ();
      index = hash % table.length;
    }

    Entry e = new Entry (hash, key, value, table [index]);
    table [index] = e;
    return null;
  }

  /**
   * Rehash the table
   */
  private void rehash () {
    Entry []  oldTable = table;

    table     = new Entry [oldTable.length * 2 + 1];
    threshold = (int)(table.length * LF);

    for (int i = oldTable.length-1; i >= 0; i--)
      for (Entry old = oldTable [i]; old != null;) {
	Entry e = old;
	old = old.next;

	int index = e.hash % table.length;
	e.next = table [index];
	table [index] = e;
      }
  }

  /** 
   * External representation
   */
  public String toString () {
    return "#[hash-table "+hashCode()+"]";
  }

  /**
   * Hash Table collision list
   */
  private static class Entry {
    int       hash;
    ScmSymbol key;
    ScmObject value;
    Entry     next;

    public Entry (int hash, ScmSymbol key, ScmObject value, Entry next) {
      this.hash  = hash;
      this.key   = key;
      this.value = value;
      this.next  = next;
    }
  }
}
