<?php
 require_once("../libs/autoload.lib.php");
 require_once("../libs/config.inc.php");

 $m = mysqlCM::getInstance();
 if ($m->connect()) {
   HTTP::getInstance()->errMysql();
 }
 $lm = loginCM::getInstance();
 $lm->startSession();

 $h = HTTP::getInstance();
 $h->parseUrl();
 
 $rpp = $config['patchPerPage'];
 if ($lm->isLogged) {
   $lo = $lm->o_login;
   $lo->fetchUCLists();
   if ($lo) {
     $val = $lo->data('patchPerPage');
     if ($val) $rpp = $val;
   }
 }

 if (isset($_POST['page']) && !empty($_POST['page'])) {
   $page = $_POST['page'];
 } else if (isset($_GET['page']) && !empty($_GET['page'])) {
   $page = $_GET['page'];
 } else {
   $page = 1;
 }
 $nb_page = 0;

 $where = " WHERE `releasedate`!='' ORDER BY `patches`.`releasedate` DESC,`patches`.`patch` DESC,`patches`.`revision` DESC";
 $bad = 0;
 $sec = 0;

 if ((isset($_POST['sec']) && !empty($_POST['sec'])) ||
     (isset($_GET['sec']) && !empty($_GET['sec']))) {
   $sec = 1;
   $where = " WHERE `pca_sec`='1' AND `releasedate`!='' ORDER BY `releasedate` DESC,`patches`.`patch` DESC,`patches`.`revision` DESC";
 }

 if ((isset($_POST['bad']) && !empty($_POST['bad'])) ||
     (isset($_GET['bad']) && !empty($_GET['bad']))) {
   $where = " WHERE `releasedate`!='' AND (`pca_bad`='1' OR status='OBSOLETE') ORDER BY `releasedate` DESC,`patches`.`patch` DESC,`patches`.`revision` DESC";
   $bad = 1;
 }

  $patches = array();
  $table = "`patches`";
  $index = "`patch`, `revision`";
  $icount = "count(`patch`) as c";

  if (($idx = mysqlCM::getInstance()->fetchIndex($icount, $table, $where)))
  {
    $nb = 0;
    if (isset($idx[0]) && isset($idx[0]['c'])) {
      $nb = $idx[0]['c'];
    }
  }

  if($nb) {
    $nb_page = $nb / $rpp;
    $nb_page = round($nb_page,0);
  }

  /* check if url is saying where to start... */
  if(isset($page) && !empty($page)) {

    if (preg_match("/[0-9]*/", $page)) {
      $start = ($page - 1) * $rpp;
      if ($start >= $nb) { /* could not start after the number of results... */
        $start = 0;
      }
    } else {
      $start = 0;
    }
  } else { /* otherwise start from scratch */
    $start = 0;
  }

  if ($start < 0) $start = 0;
  $where .= " LIMIT $start,$rpp";

  if ($nb && ($idx = mysqlCM::getInstance()->fetchIndex($index, $table, $where)))
  {
    foreach($idx as $t) {
      $g = new Patch($t['patch'], $t['revision']);
      $g->fetchFromId();
      array_push($patches, $g);
    }
  }

 $head_add = '';
 $head_add = '<link rel="alternate" type="application/rss+xml" title="Latest Patches" href="http://wesunsolve.net/rss/patches" />';
// $head_add .= '<script src="./js/jquery-1.7.1.min.js"></script>';

 $title = 'Latest Solaris patches - results from '.$start.' to '.($start+$rpp).' (of '.$nb.')';
 if ($bad) {
   $title = 'Latest obsoleted/bad Solaris patches - results from '.$start.' to '.($start+$rpp).' (of '.$nb.')';
 }
 if ($sec) {
   $title = 'Latest Solaris security patches - results from '.$start.' to '.($start+$rpp).' (of '.$nb.')';
 }

  $index = new Template("./tpl/index.tpl");
  $head = new Template("./tpl/head.tpl");
  $head->set("title", $title);
  $head->set("head_add", $head_add);
  $menu = new Template("./tpl/menu.tpl");
  $foot = new Template("./tpl/foot.tpl");
  $foot->set("start_time", $start_time);
  $content = new Template("./tpl/lpatches.tpl");
  $str = "/lpatches";
  if ($bad) {
    $str.="/bad/1";
  }
  if ($sec) {
    $str.="/sec/1";
  }
  $content->set("patches", $patches);
  $content->set("start", $start);
  $content->set("nb", $nb);
  $content->set("rpp", $rpp);
  $content->set("title", $title);
  $content->set("str", $str);
  $content->set("pagination", HTTP::pagine($page, $nb_page, $str."/page/%d"));
  if (isset($lo) && $lo) {
    $content->set("l", $lo);
    $head_add = "<script type=\"text/javascript\" src=\"/js/ax_main.js\"></script>";
    $head_add .= "<script type=\"text/javascript\" src=\"/js/ax_patch.js\"></script>";
    $head->set("head_add", $head_add);
  }

  $index->set("head", $head);
  $index->set("menu", $menu);
  $index->set("foot", $foot);
  $index->set("content", $content);
  echo $index->fetch();
?>
