//<?php
/**
 * Breadcrumbs
 *
 * カスタマイズの自由度が高いパン屑リスト
 * 
 * @category	snippet
 * @version 	1.0.5
 * @license 	http://www.gnu.org/copyleft/gpl.html GNU Public License (GPL)
 * @internal	@properties
 * @internal	@modx_category Navigation
 */

/*
 * This snippet shows the path through the various levels of site structure. It
 * is NOT necessarily the path the user took to arrive at a given page.
 */

/* -----------------------------------------------------------------------------
 * CONFIGURATION
 * -----------------------------------------------------------------------------
 * This section contains brief explanations of the available parameters.
 */

/* General setup
 * -----------------------------------------------------------------------------
 */

/* $maxCrumbs [ integer ]
 * Max number of elemetns to have in a breadcrumb path. The default 100 is an
 * arbitrarily high number that will essentially include everything. If you were
 * to set it to 2, and you were 5 levels deep, it would appear like:
 * HOME > ... > Level 3 > Level 4 > CURRENT PAGE
 * It should be noted that the "home" link, and the current page do not count as
 * they are managed by their own configuration settings.
 */
( isset($maxCrumbs) ) ? $maxCrumbs : $maxCrumbs = 100;

/* $pathThruUnPub [ 1 | 0 ]
 * When your path includes an unpublished folder, setting this to 1 (true) will
 * show all documents in path EXCEPT the unpublished. When set to 0 (false), the
 * path will not go "through" that unpublished folder and will stop there.
 */
( isset($pathThruUnPub) ) ? $pathThruUnPub : $pathThruUnPub = 1;

/* $respectHidemenu [ 0 | 1 ]
 * Setting this to 1 (true) will respect the hidemenu setting of the document
 * and not include it in trail.
 */
( isset($respectHidemenu) ) ? (int)$respectHidemenu : $respectHidemenu = 1;

/* $showCurrentCrumb [ 1 | 0 ]
 * Include the current page at the end of the trail. On by default.
 */
( isset($showCurrentCrumb) ) ? $showCurrentCrumb : $showCurrentCrumb = 1;

/* $currentAsLink [ 1 | 0 ]
 * If the current page is included, this parameter will show it as a link (1) or
 * just plain text (0).
 */
( $currentAsLink ) ? $currentAsLink : $currentAsLink = 0;

/* $linkTextField [ string ]
 * Prioritized list of fields to use as link text. Options are: pagetitle,
 * longtitle, description, menutitle. The first of these fields that has a value
 * will be the title.
 */
( isset($linkTextField) ) ? $linkTextField : $linkTextField = 'menutitle,pagetitle,longtitle';

/* $linkDescField [ string ]
 * Prioritized list of fields to use as link title text. Options are: pagetitle,
 * longtitle, description, menutitle. The first of these fields that has a value
 * will be the title.
 */
( isset($linkDescField) ) ? $linkDescField : $linkDescField = 'description,longtitle,pagetitle,menutitle';

/* $showCrumbsAsLinks [ 1 | 0 ]
 * If for some reason you want breadcrumbs to be text and not links, set to 0
 * (false).
 */
( isset($showCrumbsAsLinks) ) ? $showCrumbsAsLinks : $showCrumbsAsLinks = 1;

/* $templateSet [ string ]
 * The set of templates you'd like to use. (Templates are defined below.) It
 * will default to defaultString which replicates the output of previous
 * versions.
 */
if(isset($tpl)) {$templateSet = $tpl; unset($tpl);}

$templateSet = (!isset($templateSet) ) ? 'defaultString' : $templateSet;

/* $crumbGap [ string ]
 * String to be shown to represent gap if there are more crumbs in trail than
 * can be shown. Note: if you would like to use an image, the entire image tag
 * must be provided. When making a snippet call, you cannot use "=", so use "||"
 * instead and it will be converted for you.
 */
( isset($crumbGap) ) ? $crumbGap : $crumbGap = '...';

/* $stylePrefix [ string ]
 * Breadcrumbs will add style classes to various parts of the trail. To avoid
 * class name conflicts, you can determine your own prefix. The following
 * classes will be attached:
 * crumbBox: Span that surrounds all crumb output
 * hideCrumb: Span that surrounds the "..." if there are more crumbs than will
 * be shown
 * currentCrumb: Span or A tag surrounding the current crumb
 * firstCrumb: Span that will be applied to first crumb, whether it is "home" or
 * not
 * lastCrumb: Span surrounding last crumb, whether it is the current page or
 * not
 * crumb: Class given to each A tag surrounding the intermediate crumbs (not
 * "home", "current", or "hide")
 * homeCrumb: Class given to the home crumb
 */
( isset($stylePrefix) ) ? $stylePrefix : $stylePrefix = 'B_';



/* Home link parameters
 * -----------------------------------------------------------------------------
 * The home link is unique. It is a link that can be placed at the head of the
 * breadcrumb trail, even if it is not truly in the hierarchy.
 */

/* $showHomeCrumb [ 1 | 0 ]
 * This toggles the "home" crumb to be added to the beginning of your trail.
 */
( isset($showHomeCrumb) ) ? $showHomeCrumb : $showHomeCrumb = 1;

/* $homeId [ integer ]
 * Usually the page designated as "site start" in MODx configuration is
 * considered the home page. But if you would like to use some other document,
 * you may explicitly define it.
 */
( isset($homeId) ) ? (int)$homeId : $homeId = $modx->config['site_start'];

/* $homeCrumbTitle [ string ]
 * If you'd like to use something other than the menutitle (or pagetitle) for
 * the home link.
 */
( isset($homeCrumbTitle) ) ? $homeCrumbTitle : $homeCrumbTitle = '';

/* $homeCrumbDescription [ string ]
 * If you'd like to use a custom description (link title) on the home link. If
 * left blank, the title will follow the title order set in $titleField.
 */
( isset($homeCrumbDescription) ) ? $homeCrumbDescription : $homeCrumbDescription = '';


/* Custom behaviors
 * -----------------------------------------------------------------------------
 * The following parameters will alter the behavior of the Breadcrumbs based on
 * the page it is on.
 */

/* $showCrumbsAtHome [ 1 | 0 ]
 * You can turn off Breadcrumbs all together on the home page by setting this to
 * 1 (true);
 */
( isset($showCrumbsAtHome) ) ? $showCrumbsAtHome : $showCrumbsAtHome = 0;

/* $hideOn [ string ]
 * Comma separated list of documents you don't want Breadcrumbs on at all. If
 * you have a LOT of pages like this, you might try $hideUnder or use another
 * template. This parameter is best for those rare odd balls - otherwise it will
 * become a pain to manage.
 */
( isset($hideOn) ) ? $hideOn : $hideOn = '';

/* $hideUnder [ string ]
 * Comma separated list of parent documents, whose CHILDREN you don't want
 * Breadcrumbs to appear on at all. This enables you to hide Breadcrumbs on a
 * whole folders worth of documents by specifying the parent only. The PARENT
 * will not have Breadcrumbs hidden however. If you wanted to hide the parent
 * and the children, put the parent ID in hideUnder AND hideOn.
 */
( isset($hideUnder) ) ? $hideUnder : $hideUnder = '';

/* $stopIds [ string ]
 * Comma separated list of document IDs that when reached, stops Breadcrumbs
 * from going any further. This is useful in situations like where you have
 * language branches, and you don't want the Breadcrumbs going past the "home"
 * of the language you're in.
 */
( isset($stopIds) ) ? $stopIds : $stopIds = '';

/* $ignoreIds [ string ]
 * Comma separated list of document IDs to explicitly ignore.
 */
( isset($ignoreIds) ) ? $ignoreids : $ignoreids = '';

/* Templates
 * -----------------------------------------------------------------------------
 * In an effort to keep the MODx chunks manager from getting mired down in lots
 * of templates, Breadcrumbs templates are included here. Two sets are provided
 * prefixed with defaultString, and defaultList. You can create as many more as
 * you like, each set with it's own prefix
 */
$tpl = get_default_tpl($templateSet);
if($templateSet !== 'defaultString' && $templateSet !== 'defaultList')
{
	$chunk_tpl = get_chunk_tpl($templateSet);
	$tpl = array_merge($tpl,$chunk_tpl);
}

if(isset($crumb))             $tpl['crumb']             = fetch($crumb);
if(isset($separator))         $tpl['separator']         = fetch($separator);
if(isset($crumbContainer))    $tpl['crumbContainer']    = fetch($crumbContainerv);
if(isset($lastCrumbWrapper))  $tpl['lastCrumbWrapper']  = fetch($lastCrumbWrapper);
if(isset($firstCrumbWrapper)) $tpl['firstCrumbWrapper'] = fetch($firstCrumbWrapper);

/* -----------------------------------------------------------------------------
 * END CONFIGURATION
 * -----------------------------------------------------------------------------
 */

// Return blank if necessary: on home page
if ( !$showCrumbsAtHome && $homeId == $modx->documentIdentifier )
{
    return '';
}
// Return blank if necessary: specified pages
if ( $hideOn || $hideUnder )
{
    // Create array of hide pages
    $hideOn = str_replace(' ','',$hideOn);
    $hideOn = explode(',',$hideOn);

    // Get more hide pages based on parents if needed
    if ( $hideUnder )
    {
        $hiddenKids = array();
        // Get child pages to hide
        $hideKidsQuery = $modx->db->select('id',$modx->getFullTableName("site_content"),"parent IN ($hideUnder)");
        while ( $hideKid = $modx->db->getRow($hideKidsQuery) )
        {
            $hiddenKids[] = $hideKid['id'];
        }
        // Merge with hideOn pages
        $hideOn = array_merge($hideOn,$hiddenKids);
    }

    if ( in_array($modx->documentIdentifier,$hideOn) )
    {
        return '';
    }

}


// Initialize ------------------------------------------------------------------

// Put certain parameters in arrays
$stopIds = str_replace(' ','',$stopIds);
$stopIds = explode(',',$stopIds);
$linkTextField = str_replace(' ','',$linkTextField);
$linkTextField = explode(',',$linkTextField);
$linkDescField = str_replace(' ','',$linkDescField);
$linkDescField = explode(',',$linkDescField);
$ignoreIds = str_replace(' ','',$ignoreIds);
$ignoreIds = explode(',',$ignoreIds);

/* $crumbs
 * Crumb elements are: id, parent, pagetitle, longtitle, menutitle, description,
 * published, hidemenu
 */
$crumbs = array();
$parent = $modx->documentObject['parent'];
$output = '';
$maxCrumbs += ($showCurrentCrumb) ? 1 : 0;

// Replace || in snippet parameters that accept them with =
$crumbGap = str_replace('||','=',$crumbGap);

// Curent crumb ----------------------------------------------------------------

// Decide if current page is to be a crumb
if ( $showCurrentCrumb )
{
    $crumbs[] = array(
        'id' => $modx->documentIdentifier,
        'parent' => $modx->documentObject['parent'],
        'pagetitle' => $modx->documentObject['pagetitle'],
        'longtitle' => $modx->documentObject['longtitle'],
        'menutitle' => $modx->documentObject['menutitle'],
        'description' => $modx->documentObject['description']);
}

// Intermediate crumbs ---------------------------------------------------------


// Iterate through parents till we hit root or a reason to stop
$loopSafety = 0;
while ( $parent && $parent!=$modx->config['site_start'] && $loopSafety < 1000 )
{
    // Get next crumb
    $tempCrumb = $modx->getPageInfo($parent,0,"id,parent,pagetitle,longtitle,menutitle,description,published,hidemenu");

    // Check for include conditions & add to crumbs
    if (
        $tempCrumb['published'] &&
        ( !$tempCrumb['hidemenu'] || !$respectHidemenu ) &&
        !in_array($tempCrumb['id'],$ignoreIds)
    )
    {
        // Add crumb
        $crumbs[] = array(
        'id' => $tempCrumb['id'],
        'parent' => $tempCrumb['parent'],
        'pagetitle' => $tempCrumb['pagetitle'],
        'longtitle' => $tempCrumb['longtitle'],
        'menutitle' => $tempCrumb['menutitle'],
        'description' => $tempCrumb['description']);
    }

    // Check stop conditions
    if (
        in_array($tempCrumb['id'],$stopIds) ||  // Is one of the stop IDs
        !$tempCrumb['parent'] || // At root
        ( !$tempCrumb['published'] && !$pathThruUnPub ) // Unpublished
    )
    {
        // Halt making crumbs
        break;
    }

    // Reset parent
    $parent = $tempCrumb['parent'];

    // Increment loop safety
    $loopSafety++;
}

// Home crumb ------------------------------------------------------------------

if ( $showHomeCrumb && $homeId != $modx->documentIdentifier && $homeCrumb = $modx->getPageInfo($homeId,0,"id,parent,pagetitle,longtitle,menutitle,description,published,hidemenu") )
{
    $crumbs[] = array(
    'id' => $homeCrumb['id'],
    'parent' => $homeCrumb['parent'],
    'pagetitle' => $homeCrumb['pagetitle'],
    'longtitle' => $homeCrumb['longtitle'],
    'menutitle' => $homeCrumb['menutitle'],
    'description' => $homeCrumb['description']);
}


// Process each crumb ----------------------------------------------------------
$pretemplateCrumbs = array();

foreach ( $crumbs as $c )
{

    // Skip if we've exceeded our crumb limit but we're waiting to get to home
    if ( count($pretemplateCrumbs) > $maxCrumbs && $c['id'] != $homeId )
    {
        continue;
    }

    $text = '';
    $title = '';
    $pretemplateCrumb = '';

    // Determine appropriate span/link text: home link specified
    if ( $c['id'] == $homeId && $homeCrumbTitle )
    {
        $text = $homeCrumbTitle;
    }
    else
    // Determine appropriate span/link text: home link not specified
    {
        for ($i = 0; !$text && $i < count($linkTextField); $i++)
        {
            if ( $c[$linkTextField[$i]] )
            {
                $text = $c[$linkTextField[$i]];
            }
        }
    }

    // Determine link/span class(es)
    if ( $c['id'] == $homeId )
    {
        $crumbClass = $stylePrefix.'homeCrumb';
    }
    else if ( $modx->documentIdentifier == $c['id'] )
    {
        $crumbClass = $stylePrefix.'currentCrumb';
    }
    else
    {
        $crumbClass = $stylePrefix.'crumb';
    }

    // Make link
    if (
        ( $c['id'] != $modx->documentIdentifier && $showCrumbsAsLinks ) ||
        ( $c['id'] == $modx->documentIdentifier && $currentAsLink )
    )
    {
        // Determine appropriate title for link: home link specified
        if ( $c['id'] == $homeId && $homeCrumbDescription )
        {
            $title = htmlspecialchars($homeCrumbDescription);
        }
        else
        // Determine appropriate title for link: home link not specified
        {
            for ($i = 0; !$title && $i < count($linkDescField); $i++)
            {
                if ( $c[$linkDescField[$i]] )
                {
                    $title = htmlspecialchars($c[$linkDescField[$i]]);
                }
            }
        }


        $pretemplateCrumb .= '<a class="'.$crumbClass.'" href="'.($c['id'] == $modx->config['site_start'] ? $modx->config['base_url'] : $modx->makeUrl($c['id'])).'" title="'.$title.'">'.$text.'</a>';
    }
    else
    // Make a span instead of a link
    {
       $pretemplateCrumb .= '<span class="'.$crumbClass.'">'.$text.'</span>';
    }

    // Add crumb to pretemplate crumb array
    $pretemplateCrumbs[] = $pretemplateCrumb;

    // If we have hit the crumb limit
    if ( count($pretemplateCrumbs) == $maxCrumbs )
    {
        if ( count($crumbs) > ($maxCrumbs + (($showHomeCrumb) ? 1 : 0)) )
        {
            // Add gap
            $pretemplateCrumbs[] = '<span class="'.$stylePrefix.'hideCrumb'.'">'.$crumbGap.'</span>';
        }

        // Stop here if we're not looking for the home crumb
        if ( !$showHomeCrumb )
        {
            break;
        }
    }
}

// Put in correct order for output
$pretemplateCrumbs = array_reverse($pretemplateCrumbs);

// Wrap first/last spans
$pretemplateCrumbs[0] = str_replace(
    array('[+firstCrumbClass+]','[+firstCrumbSpanA+]'),
    array($stylePrefix.'firstCrumb',$pretemplateCrumbs[0]),
    $tpl['firstCrumbWrapper']
);
$pretemplateCrumbs[(count($pretemplateCrumbs)-1)] = str_replace(
    array('[+lastCrumbClass+]','[+lastCrumbSpanA+]'),
    array($stylePrefix.'lastCrumb',$pretemplateCrumbs[(count($pretemplateCrumbs)-1)]),
    $tpl['lastCrumbWrapper']
);

// Insert crumbs into crumb template
$processedCrumbs = array();
foreach ( $pretemplateCrumbs as $pc )
{
    $processedCrumbs[] = str_replace('[+crumb+]',$pc,$tpl['crumb']);
}

// Combine crumbs together into one string with separator
$processedCrumbs = implode($tpl['separator'],$processedCrumbs);

// Put crumbs into crumb container template
$container = str_replace(
    array('[+crumbBoxClass+]','[+crumbs+]'),
    array($stylePrefix.'crumbBox',$processedCrumbs),
    $tpl['crumbContainer']
    );

// Return crumbs
return $container;



function get_default_tpl($templateSet)
{
	$templateSet = strtolower($templateSet);
	switch($templateSet)
	{
		case 'defaultlist':
		case 'list':
		case 'li':
		{
			$tpl['crumb']             = '<li>[+crumb+]</li>';
			$tpl['separator']         = '';
			$tpl['crumbContainer']    = '<ul class="[+crumbBoxClass+]">[+crumbs+]</ul>';
			$tpl['firstCrumbWrapper'] = '<span class="[+firstCrumbClass+]">[+firstCrumbSpanA+]</span>';
			$tpl['lastCrumbWrapper']  = '<span class="[+lastCrumbClass+]">[+lastCrumbSpanA+]</span>';
			break;
		}
		default:
		{
			$tpl['crumb']             = '[+crumb+]';
			$tpl['separator']         = ' &raquo; ';
			$tpl['crumbContainer']    = '<span class="[+crumbBoxClass+]">[+crumbs+]</span>';
			$tpl['firstCrumbWrapper'] = '<span class="[+firstCrumbClass+]">[+firstCrumbSpanA+]</span>';
			$tpl['lastCrumbWrapper']  = '<span class="[+lastCrumbClass+]">[+lastCrumbSpanA+]</span>';
		}
	}
	return $tpl;
}

function get_chunk_tpl($templateSet)
{
	global $modx;
	$src = $modx->getChunk($templateSet);
	$lines = explode("\n", $src);
	foreach($lines as $line)
	{
		$line = ltrim($line);
		if(!empty($line) && $line[0] == '&' && strpos($line,'=')!==false)
		{
			list($key,$value) = explode('=',$line,2);
			$key   = trim($key,'& ');
			$value = trim($value,'`');
			$tpl[$key] = $value;
		}
	}
	return $tpl;
}

function fetch($value)
{
	global $modx;
	$template = '';
	
	if(substr($value, 0, 5) == '@FILE')
	{
		$value = substr($value, 6);
		$value = trim($value);
		$value = MODX_BASE_PATH . ltrim($value,'/');
		$template = file_get_contents($value);
	}
	elseif(substr($value, 0, 5) == '@CODE')
	{
		$template = substr($value, 6);
	}
	elseif($modx->getChunk($value) != '')
	{
		$template = $modx->getChunk($value);
	}
	else
	{
		$template = $value;
	}
	return $template;
}
