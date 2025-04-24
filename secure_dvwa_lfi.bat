@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

:: Chemin vers DVWA
set "DVWA_PATH=C:\xampp\htdocs\dvwa"
set "INDEX_FILE=%DVWA_PATH%\index.php"
set "SECURE_DIR=%DVWA_PATH%\includes\pages"

echo 🔧 Création du dossier sécurisé...
mkdir "%SECURE_DIR%"

echo ✏️ Création d'un fichier test...
echo <?php echo 'Page autorisée incluse.'; ?> > "%SECURE_DIR%\hello.php"

echo 🛑 Sauvegarde de index.php...
copy /Y "%INDEX_FILE%" "%INDEX_FILE%.bak"

echo ⚙️ Remplacement de index.php par version sécurisée...
(
echo ^<?php
echo define('DVWA_WEB_PAGE_TO_ROOT', '');
echo require_once DVWA_WEB_PAGE_TO_ROOT . 'dvwa/includes/dvwaPage.inc.php';
echo dvwaPageStartup(array('authenticated'));
echo $pageData = dvwaPageNewGrab();
echo $pageData['title'] = 'Welcome' . $pageData['title_separator'] . $pageData['title'];
echo $pageData['page_id'] = 'home';
echo $pageData['body'] .= "";
echo if (isset($_GET['page'])) {
echo     $userPage = $_GET['page'];
echo     if (
echo         strpos($userPage, 'php://') !== false ^|^|
echo         strpos($userPage, 'filter') !== false ^|^|
echo         strpos($userPage, 'data://') !== false ^|^|
echo         strpos($userPage, 'input://') !== false
echo     ) {
echo         die('⛔ Tentative d’acces interdit detectee.');
echo     }
echo     if (preg_match('/\.\.\//', $userPage)) {
echo         die('⛔ Inclusion de fichiers interdite.');
echo     }
echo     $allowedDir = realpath('./includes/pages/');
echo     $targetFile = realpath($userPage);
echo     if ($targetFile && strpos($targetFile, $allowedDir) === 0) {
echo         include($targetFile);
echo     } else {
echo         die('⛔ Acces refuse.');
echo     }
echo }
echo $pageData['body'] .= <<<HTML
echo ^<div class="body_padded"^>
echo ^<h1^>Welcome to Damn Vulnerable Web Application!^</h1^>
echo ^<p^>DVWA est une application volontairement vulnérable...^</p^>
echo ^</div^>
echo HTML;
echo dvwaHtmlEcho($pageData);
echo ?>
) > "%INDEX_FILE%"

echo ✅ Sécurisation terminée !
echo 🌐 Tu peux tester ici : http://localhost/dvwa/?page=includes/pages/hello.php
echo ❗ Toute tentative LFI ou php://filter sera bloquée.

pause
