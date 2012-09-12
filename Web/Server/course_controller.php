<?php	
	require_once("course.php");
	
	function add_course($mysqli, $department,$course_number, $course_description)
	{
		return $mysqli->query("INSERT INTO course VALUES ('DEFAULT','" . $department . "','" . $course_number . "','" . $course_description . "')");
	}
	
	function update_course($mysqli,$CID, $department,$course_number, $course_description)
	{
		return $mysqli->query("UPDATE course SET '" . Course.departmentQueryString  ."' = '" . $department . "', '" . Course.course_numberQueryString  ."' = '" . $course_number . "', '" . Course.CIDQueryString  ."' = '" . $course_description . "' WHERE '" . Course.CIDQueryString  ."' = '" . $CID . "'");
	}
	
	function delete_course($mysqli, $CID)
	{
		return $mysqli->query("DELETE FROM course WHERE '" . Course.CIDQueryString  ."' = '" . $CID ."'");
	}
	
	function get_course_by_cid($mysqli, $CID)
	{
		$result = $mysqli->query("SELECT '" . Course.CIDQueryString  ."', '" . Course.departmentQueryString  ."', '" . Course.course_numberQueryString  ."', '" . Course.course_descriptionQueryString  ."' FROM course WHERE '" . Course.CIDQueryString  ."' = '" . $CID . "'");
		return $result->fetch_object("Course");
	}
	
	function get_courses_by_crn($mysqli, $course_number)
	{
		$result = $mysqli->query("SELECT '" . Course.CIDQueryString  ."', '" . Course.departmentQueryString  ."', '" . Course.course_numberQueryString  ."', '" . Course.course_descriptionQueryString  ."' FROM course WHERE '" . Course.course_numberQueryString  ."' LIKE '%" . $course_number . "%'");
		$results_array = array();
		while($result_obj = $result->fetch_object("Course"))
		{
			array_push($results_array, $result_obj);
		}
		return $results_array;
	}
?>