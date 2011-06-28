<?php
/**
 * File object
 *
 * @author Gouverneur Thomas <tgo@ians.be>
 * @copyright Copyright (c) 2011, Gouverneur Thomas
 * @version 1.0
 * @package objects
 * @category classes
 * @subpackage backend
 * @filesource
 */


class File extends mysqlObj
{
  /* Data Var */
  public $id = -1;
  public $name = "";
  
  /* Lists */
  public $a_patches = array();

 /**
  * Constructor
  */
  public function __construct($id=-1)
  {
    $this->id = $id;
    $this->_table = "files";
    $this->_nfotable = "";
    $this->_my = array(
                        "id" => SQL_INDEX,
                        "name" => SQL_PROPE
                 );

    $this->_myc = array( /* mysql => class */
                        "id" => "id",
                        "name" => "name"
                 );
  }

}
?>