<?php
  if ($start != 0 && $start >= $rpp) {
    $idprev = $start - $rpp;
  }
  if (($start + 50) >= $nb) {
    $idnext = $nb - 1;
  } else {
    $idnext = $start + $rpp;
  }
  $h = HTTP::getInstance();
  if (!$h->css) $h->fetchCSS();
?>
    <div id="d_content">
     <h2 class="grid_10 push_1 alpha omega">User panel</h2>
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
<?php if (isset($error)) { ?>
    <br/>
    <span class="red"><p><?php echo $error; ?></p></span>
<?php } ?>
   <?php if (isset($lvp)) { ?>
   <div class="listbox grid_<?php echo $h->css->s_box; ?> firstbox alpha">
    <h3>Last viewed patches</h3>
    <ul>
     <?php foreach($lvp as $w => $p) { ?>
     <li><a href="/patch/id/<?php echo $p->name(); ?>"><?php echo $p->name(); ?></a> on <?php echo date(HTTP::getDateTimeFormat(), $p->u_when); ?></li>
     <?php } ?>
    </ul>
   </div>
   <?php } ?>
   <?php if (isset($lvb)) { ?>
   <div class="listbox grid_5 omega">
    <h3>Last viewed bugs</h3>
    <ul>
     <?php foreach($lvb as $b) { ?>
     <li><a href="/bugid/id/<?php echo $b->id; ?>"><?php echo $b->id; ?></a> on <?php echo date(HTTP::getDateTimeFormat(), $b->u_when); ?></li>
     <?php } ?>
    </ul>
   </div>
   <div class="clear"></div>
   <?php } ?>
   <div class="clear"></div>

  <h4>Custom Lists (<a href="/add_clist">Add</a>) (<a href="http://wiki.wesunsolve.net/PatchesLists">Documentation</a>)</h4>
    <p>You have <?php echo count($uclists); ?> custom list of patches</p>
    <?php if (count($uclists)) { ?>
    <table class="ctable">
     <tr>
      <th>List Name</th>
      <th># of Patchs</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
     </tr>
<?php $i=1; foreach($uclists as $l) { ?>
     <tr class="<?php if ($i % 2) { echo "tdp"; } else { echo "tdup"; } ?>">
      <td><?php echo $l->name; ?></td>
      <td style="text-align: center;"><?php echo count($l->a_patches); ?></td>
      <td style="text-align: center;"><a href="/add2uclist/uid/<?php echo $l->id; ?>">Add Patches</a></td>
      <td style="text-align: center;"><a href="/uclist/i/<?php echo $l->id; ?>">View</a></td>
      <td style="text-align: center;"><a href="/del_uclist/i/<?php echo $l->id; ?>">Del</a></td>
      <td style="text-align: center;"><a href="/ucl_pdiag/i/<?php echo $l->id; ?>">Generate patchdiag.xref</a></td>
      <td style="text-align: center;"><a href="/uclreadme/i/<?php echo $l->id; ?>">Fetch READMEs</a></td>
     </tr>
<?php $i++; } ?>
    </table>
<?php  } ?>
    <h4>Servers (<a href="/register_srv">Add</a>) (<a href="http://wiki.wesunsolve.net/ServerManagement">Documentation</a>)</h4>
    <p>You have <?php echo $nb; ?> server registered</p>
    <p class="paging"><?php echo $pagination; ?></p> 
    <table class="ctable">
     <tr>
      <th>Server Name</th>
      <th>Comment</th>
      <th># of Patch level</th>
      <th>View Patching level</th>
      <th>Add Patching level</th>
      <th></th>
     </tr>
<?php $i=1; foreach($servers as $srv) { ?>
     <tr class="<?php if ($i % 2) { echo "tdp"; } else { echo "tdup"; } ?>">
      <td><?php echo $srv->name; ?></td>
      <td><?php echo $srv->comment; ?></td>
      <td style="text-align: center;"><?php echo $srv->countPLevels(); ?></td>
      <td style="text-align: center;"><a href="/plevel/s/<?php echo $srv->id; ?>">View</a></td>
      <td style="text-align: center;"><a href="/add_plevel/s/<?php echo $srv->id; ?>">Add</a></td>
      <td style="text-align: center;"><a href="/del_srv/s/<?php echo $srv->id; ?>">Delete</a></td>
     </tr>
<?php $i++; } ?>
    </table>
    <p class="paging"><?php echo $pagination; ?></p> 
    <h4>Patch reports (<a href="/add_report">Add</a>) (<a href="http://wiki.wesunsolve.net/MailReports">Documentation</a>)</h4>
    <p>You have <?php echo count($ureports); ?> reports</p>
    <table class="ctable">
     <tr>
      <th>Patch Level</th>
      <th>Patchdiag Delay</th>
      <th>Last Sent</th>
      <th>Frequency</th>
      <th>Next report</th>
      <th></th>
      <th></th>
     </tr>
<?php $i=1; foreach($ureports as $r) { ?>
     <tr class="<?php if ($i % 2) { echo "tdp"; } else { echo "tdup"; } ?>">
      <td><?php echo $r->o_server.' / '.$r->o_plevel; ?></td>
      <td><?php if ($r) { echo $r->pdiag_delay.'days'; } else { echo "latest"; } ?></td>
      <td><?php if ($r->lastrun) { echo date(HTTP::getDateFormat(), $r->lastrun); } else { echo 'never'; } ?></td>
      <td><?php echo $r->frequency/86400; ?> day(s)</td>
      <td><?php echo date(HTTP::getDateFormat(), $r->nextrun()); ?></td>
      <td style="text-align: center;"><a href="/send_ureport/r/<?php echo $r->id; ?>">Send Now</a></td>
      <td style="text-align: center;"><a href="/del_ureport/r/<?php echo $r->id; ?>">Delete</a></td>
     </tr>
<?php $i++; } ?>
    </table>

    <h4>Other tools</h4>
    <ul class="bullet">
      <li><a href="/srvUpgrade">Server upgrade</a> through patchdiag.xref generation</li>
    </ul>
   </div><!-- d_content_box -->
  </div><!-- grid_19 -->
 </div><!-- d_content -->
