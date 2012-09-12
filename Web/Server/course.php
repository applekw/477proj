<?php
	include_once("JSONEncodableObject.php");
	class Course extends JSONEncodableObject
	{
		public $CID;
		public $department;
		public $course_number;
		public $course_description;
		
		public static $CIDQueryString = "CID";
		public static $departmentQueryString = "department";
		public static $course_numberQueryString = "course_number";
		public static $course_descriptionQueryString = "course_description";
		
		public function __toString() {
			return $this->course_number;
		}
	}
?>