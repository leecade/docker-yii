<?php
require_once(Yii::getPathOfAlias('application.vendor.smarty').DIRECTORY_SEPARATOR.'Smarty.class.php');

define('VIEWS_DIR',Yii::getPathOfAlias('application.views'));
define('RUNTIME_DIR',Yii::getPathOfAlias('application.runtime'));

class CSmarty extends Smarty {
  const DS = DIRECTORY_SEPARATOR;
  function __construct() {
    parent::__construct();
    $this->template_dir = VIEWS_DIR.self::DS.'tpl';
    $this->compile_dir = RUNTIME_DIR.self::DS.'template_c';
    $this->cache_dir = RUNTIME_DIR.self::DS.'cache';
    $this->caching = false;
    $this->left_delimiter =  '{';
    $this->right_delimiter = '}';
    $this->cache_lifetime = 3600;
  }
  function init() {}
}
