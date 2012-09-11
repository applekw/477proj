<?php
	function getDBCon() {
		$host = "localhost:3306";
		$username = "lcproj1";
		$password = "LearningCenter";
		$db_name = "lcdb1";
		return new mysqli($host, $username, $password, $db_name);
	}
?>