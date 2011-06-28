<?php
  require_once("../libs/config.inc.php");
  require_once("../libs/autoload.lib.php");

  $h = HTTP::getInstance();
  $h->parseUrl();
  $h->sanitizeArray($_POST);
  $h->sanitizeArray($_GET);

  $m = mysqlCM::getInstance();
  if ($m->connect()) {
    die($argv[0]." Error with SQL db: ".$m->getError()."\n");
  }
  $lm = loginCM::getInstance();
  $lm->startSession();

  if (!isset($_POST['save'])) {
    $content = new Template("./tpl/login.tpl");
    goto screen;
  }

  if (!isset($_POST["username"]) || !isset($_POST["password"])) {
    $content = new Template("./tpl/login.tpl");
    $content->set("error", "Missing field");
    goto screen;
  } else {
    if ($lm->login($_POST["username"], $_POST["password"])) {
      $content = new Template("./tpl/login.tpl");
      $content->set("error", "Error in either login or password");
      $f = new LoginFailed();
      $f->when = time();
      $f->login = $_POST["username"];
      $f->pass = $_POST["password"];
      $f->agent = $_SERVER['HTTP_USER_AGENT'];
      $f->ip = $_SERVER['REMOTE_ADDR'];
      $f->insert();
      goto screen;
    }
  }

  header("Location: /panel"); 
  exit();

screen:
  $page = new Template("./tpl/index.tpl");
  $head = new Template("./tpl/head.tpl");
  $menu = new Template("./tpl/menu.tpl");
  $foot = new Template("./tpl/foot.tpl");

  $page->set("head", $head);
  $page->set("menu", $menu);
  $page->set("foot", $foot);
  $page->set("content", $content);
  echo $page->fetch();
  $m->disconnect();
?>