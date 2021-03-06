<?php
  $h = HTTP::getInstance();
?>
    <div id="d_content">
     <h2 class="grid_10 push_1 alpha omega">Bundle <?php echo $bundle->synopsis; ?></h2>
     <p id="titlecomment" class="push_4 grid_5"><?php echo count($bundle->a_comments); ?> Comments | <a href="#comments">view</a> / <a href="/
add_comment/id_on/<?php echo $bundle->id; ?>/type/bundle">add</a></p>
     <div class="clear"></div>
     <div class="grid_<?php echo ($h->css->s_total - $h->css->s_menu); ?> alpha omega">
      <div class="d_content_box">
       <div style="height: 30px" class="push_<?php echo $h->css->p_snet; ?> grid_<?php echo $h->css->s_snet; ?>">
        <div class="addthis_toolbox addthis_default_style" id="snet">
         <a class="addthis_button_facebook"></a>
         <a class="addthis_button_twitter"></a>
         <a class="addthis_button_email"></a>
         <a class="addthis_button_print"></a>
         <a class="addthis_button_google_plusone"></a>
        </div>
       </div>
       <div class="clear clearfix"></div>
	     <h3>General information</h3>
		<ul class="listinfo">
		 <li>Synopsis: <?php echo $bundle->synopsis; ?></li>
		 <li>Release date: <?php if($bundle->lastmod) echo date(HTTP::getDateFormat(), $bundle->lastmod); ?></li>
		 <li>Archive size: <?php echo $bundle->size; ?> bytes (<?php echo round($bundle->size / 1024 / 1024, 2); ?> MBytes)</li>
		 <li>Filename: <?php echo $bundle->filename; ?></li>
                 <li><a href="/readme/bn/<?php echo $bundle->id; ?>">View README</a></li>
                 <li><a href="https://getupdates.oracle.com/patch_cluster/<?php echo $bundle->filename; ?>">Download</a> at Oracle MOS</li>
<?php if ($is_dl && $archive) { ?>
		<li><a href="/pdl/b/<?php echo $bundle->id; ?>">Download</a> locally</a>
<?php } ?>
		</ul>
                <h3>Patch included in this cluster</h3>
                <?php if (!count($bundle->a_patches)) { echo "<p>There is no patch included in ".$bundle->synopsis."</p>"; } else { ?>
  <div class="ctable">
   <table id="legend" class="ctable"><tr>
                                <td class="greentd">RECOMMENDED</td>
                                <td class="orangetd">SECURITY</td>
                                <td class="redtd">WITHDRAWN</td>
                                <td class="browntd">OBSOLETE</td>
                        </tr></table>
		<table id="tbl_patches" class="ctable">
		<tr>
    		  <th>Patch ID</th>
		  <th>Release date</th>
    		  <th>Synopsis</th>
	        </tr>
                <?php foreach ($bundle->a_patches as $p) { 
	          $f = $p->flags();
	          $isf = strlen($f);
		?>
		<tr>
		 <td <?php echo $p->color(); ?>><?php if ($p->isNew()) { ?><img class="newimg" src="/img/new.png" alt="New"/> <?php } ?><a href="/patch/id/<?php echo $p->name(); ?>"><?php echo $p->name(); ?></a></td>
	         <td><?php echo date(HTTP::getDateFormat(), $p->releasedate); ?></td>
                 <td style="text-align: left"><?php if ($isf) echo '['.$f.']'; ?><?php echo HTTP::linkize(substr($p->synopsis,0, $h->css->s_strip)); ?></td>
		</tr>
                <?php } ?>
		</table>
                <?php } ?>
   </div><!-- d_content_box -->
  </div><!-- grid_19 -->
 </div><!-- d_content -->
