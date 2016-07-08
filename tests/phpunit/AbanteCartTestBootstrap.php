<?php

class AbanteCartTest extends PHPUnit_Framework_TestCase {
	
	protected $registry;

	
	public function __get($key) {
		return $this->registry->get($key);
	}
	
	public function __set($key, $value) {
		$this->registry->set($key, $value);
	}	
	
	public function loadConfiguration($path) {


		// Configuration
		if (file_exists($path) && filesize($path)) {
			require_once($path);
		} else {
			exit($path);
			throw new Exception('AbanteCart has to be installed first!');
		}

		// New Installation
		if (!defined('DB_DATABASE')) {
			throw new Exception('AbanteCart has to be installed first!');
		}
	}
	
	public function __construct() {

		$GLOBALS[ 'error_descriptions' ] = 'Abantecart PhpUnit test';
		require('config.php');
		$_SERVER['HTTP_HOST'] = ABC_TEST_HTTP_HOST;
		$_SERVER['PHP_SELF'] = ABC_TEST_PHP_SELF;


		// Required PHP Version
		define('MIN_PHP_VERSION', '5.3.0');
		if (version_compare(phpversion(), MIN_PHP_VERSION, '<') == TRUE) {
			throw new Exception( MIN_PHP_VERSION . '+ Required for AbanteCart to work properly! Please contact your system administrator or host service provider.');
		}

		// Load Configuration

		// Real path (operating system web root) to the directory where abantecart is installed
		$root_path = ABC_TEST_ROOT_PATH;

		// Windows IIS Compatibility
		if (stristr(PHP_OS, 'WIN')) {
			define('IS_WINDOWS', true);
			$root_path = str_replace('\\', '/', $root_path);
		}
		define('DIR_ROOT', $root_path);
		define('DIR_CORE', DIR_ROOT . '/core/');

		$this->loadConfiguration(DIR_ROOT . '/system/config.php');

		//set server name for correct email sending
		if(defined('SERVER_NAME') && SERVER_NAME!=''){
		  putenv("SERVER_NAME=".SERVER_NAME);
		}


		//purge _GET
		$get = array('mode'=> isset($_GET['mode']) ? $_GET['mode'] : '');
		if(!in_array($get['mode'],array('run', 'query'))){ // can be 'query' or 'run'
			$get['mode'] = 'run';
		}
		// if task details needed for ajax step-by-step run
		if($get['mode']=='query'){
			$get['task_name'] = $_GET['task_name'];
		}
		$_GET = $get;
		unset($get);

		$_GET['s'] = ADMIN_PATH; // sign of admin side for controllers run from dispatcher
		// Load all initial set up
		require_once(DIR_ROOT . '/core/init.php');
		unset($_GET['s']);// not needed anymore


		// Registry
		$this->registry = Registry::getInstance();
	}	
	
	public function customerLogin($user,$password,$override=false) {
		$logged = $this->customer->login($user,$password,$override);		
				
		if (!$logged) {
			throw new Exception('Could not login customer');	
		}		
	}
	
	public function customerLogout() {		
		if ($this->customer->isLogged()) {		
			$this->customer->logout();		
		}
	}
	

	public function getOutput() {
		
		$class = new ReflectionClass("Response");
		$property = $class->getProperty("output");
		$property->setAccessible(true);
		return $property->getValue($this->response);
		
	}	
	
/*	public function dispatchAction($route) {
		
		// Router
		if (!empty($route)) {
			$action = new Action($route);
		} else {
			$action = new Action('common/home');
		}
		
		// Dispatch
		$this->front->dispatch($action, new Action('error/not_found'));
		
		return $this->response;
	}
	
	public function loadModelByRoute($route) {
		$this->load->model($route);		
		$parts = explode("/",$route);
		
		$model = 'model';
				
		foreach ($parts as $part) {
			$model .= "_" . $part;
		}
		
		return $this->$model;
		
	}*/
	
		
}