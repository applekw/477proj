<?php
	include_once("tutor.php");
	include_once("course.php");
	include_once("tutor_timeslot.php");
	include_once("course_controller.php");
	
	//NOTE: Expects the classes passed in to already be in the course table
	//      drop-down list could ensure this
	//TODO: add support for pictures once their implementation is finalized, fix adding courses
	function add_tutor($mysqli, $name,$year,$TID,$major,$room_number,$about_tutor)
	{	
		return $mysqli->query("INSERT INTO tutor ('" . Tutor.nameQueryString  ."','" . Tutor.yearQueryString  ."', '" . Tutor.TIDQueryString  ."', '" . Tutor.majorQueryString  ."', '" . Tutor.Room_NumberQueryString  ."', '" . Tutor.about_tutorQueryString  ."') VALUES ('". $mysqli->real_escape_string($name) ."' , '". $mysqli->real_escape_string($year) ."' , '". $mysqli->real_escape_string($TID) ."', '". $mysqli->real_escape_string($major) ."','" . $mysqli->real_escape_string($room_number) . "','" . $mysqli->real_escape_string($about_tutor) ."')");
	}
	
	function update_tutor($mysqli, $name, $year, $TID, $major, $room_number, $about_tutor)
	{	
		return $mysqli->query("UPDATE tutor SET '" . Tutor.nameQueryString  ."' = '" . $mysqli->real_escape_string($name) . "', '" . Tutor.yearQueryString  ."' = '" . $mysqli->real_escape_string($year) . "', '" . Tutor.majorQueryString  ."' = '" . $mysqli->real_escape_string($major) . "', '" . Tutor.Room_NumberQueryString  ."' = '" . $mysqli->real_escape_string($room_number) . "', '" . Tutor.about_tutorQueryString  ."' = '" . $mysqli->real_escape_string($about_tutor) . "' WHERE '" . Tutor.TIDQueryString  ."' = '" . $mysqli->real_escape_string($TID) ."'");
	}
	
	function delete_tutor($mysqli, $TID)
	{
		$deletion_result = $mysqli->query("DELETE FROM tutor_course WHERE '" . Tutor.TIDQueryString  ."' = '" . $mysqli->real_escape_string($TID) . "'");
		$deletion_result = $mysqli->query("DELETE FROM tutor_timeslots WHERE '" . Tutor.TIDQueryString  ."' = '" . $mysqli->real_escape_string($TID) . "'");
		$deletion_result = $mysqli->query("DELETE FROM booked_timeslots WHERE '" . Tutor.TIDQueryString  ."' = '" . $mysqli->real_escape_string($TID) . "'");
		$deletion_result = $mysqli->query("DELETE FROM tutor WHERE '" . Tutor.TIDQueryString  ."' = '" . $mysqli->real_escape_string($TID). "'");
		
		return $deletion_result;
	}
	
	function add_course_for_tutor($mysqli, $TID,$CID)
	{	
		return $mysqli->query("INSERT INTO tutor_course ('" . Tutor.TIDQueryString  ."','" . Course.CIDQueryString  ."') VALUES ('". $mysqli->real_escape_string($TID) . "','" . $mysqli->real_escape_string($CID) ."')");
	}
	
	function remove_course_for_tutor($mysqli, $TID,$CID)
	{	
		return $mysqli->query("DELETE FROM tutor_course WHERE '" . Tutor.TIDQueryString  ."' = '". $mysqli->real_escape_string($TID) . "' AND '" . Course.CIDQueryString  ."' = '" . $mysqli->real_escape_string($CID) ."'");
	}
	
	function add_timeslot_for_tutor($mysqli, $TID, $TSID)
	{	
		return $mysqli->query("INSERT INTO tutor_timeslot ('" . Tutor.TIDQueryString  ."','" . tutor_timeslot.TSIDQueryString  ."') VALUES ('". $mysqli->real_escape_string($TID) . "','" . $mysqli->real_escape_string($TSID) ."')");
	}
	
	function remove_timeslot_for_tutor($mysqli, $TID, $TSID)
	{	
		return $mysqli->query("DELETE FROM tutor_timeslot WHERE '" . Tutor.TIDQueryString  ."' = '". $mysqli->real_escape_string($TID) . "' AND '" . tutor_timeslot.TSIDQueryString  ."' = '" . $mysqli->real_escape_string($TSID) ."'");
	}
	
	function add_timeslot_for_tutor_on_day($mysqli, $TID, $TSID, $dayofweek)
	{	
		return $mysqli->query("INSERT INTO tutor_timeslot ('" . Tutor.TIDQueryString  ."','" . tutor_timeslot.TSIDQueryString  ."', DAYOFWEEK) VALUES ('". $mysqli->real_escape_string($TID) . "','" . $mysqli->real_escape_string($TSID) ."','" . $mysqli->real_escape_string($dayofweek) . "')");
	}
	
	function remove_timeslot_for_tutor_on_day($mysqli, $TID, $TSID, $dayofweek)
	{	
		return $mysqli->query("DELETE FROM tutor_timeslot WHERE '" . Tutor.TIDQueryString  ."' = '". $mysqli->real_escape_string($TID) . "' AND '" . tutor_timeslot.TSIDQueryString  ."' = '" . $mysqli->real_escape_string($TSID) ."' AND DAYOFWEEK = '" . strtoUpper($mysqli->real_escape_string($dayofweek)) ."'");
	}
	
	function get_tutor_by_id($mysqli, $tutor_id)
	{	
		$result = $mysqli->query("SELECT tutor.'" . Tutor.TIDQueryString  ."', tutor.'" . Tutor.nameQueryString  ."', tutor.'" . Tutor.yearQueryString  ."', tutor.'" . Tutor.majorQueryString  ."', tutor.'" . Tutor.Room_NumberQueryString  ."', tutor.'" . Tutor.about_tutorQueryString  ."' FROM tutor WHERE tutor.'" . Tutor.TIDQueryString  ."' = '" . $mysqli->real_escape_string($tutor_id) . "'");
		$tutor_object = $result->fetch_object("tutor");
		return $tutor_object;
	}
	
	function get_tutors_by_course($mysqli, $course)
	{
		$result = $mysqli->query("SELECT DISTINCT tutor.'" . Tutor.TIDQueryString  ."', tutor.'" . Tutor.nameQueryString  ."', tutor.'" . Tutor.yearQueryString  ."', tutor.'" . Tutor.majorQueryString  ."', tutor.'" . Tutor.Room_NumberQueryString  ."', tutor.'" . Tutor.about_tutorQueryString  ."' FROM course INNER JOIN (tutor_course INNER JOIN tutor ON (tutor_course.'" . Tutor.TIDQueryString  ."'=tutor.'" . Tutor.TIDQueryString  ."')) ON (course.'" . Course.CIDQueryString  ."'=tutor_course.'" . Course.CIDQueryString  ."') WHERE course.'" . Course.course_numberQueryString  ."' LIKE '%" . $mysqli->real_escape_string($course) . "%'");
		$results_array = array();
		while($result_obj = $result->fetch_object("tutor"))
		{
			array_push($results_array, $result_obj);
		}
		return $results_array;
	}
	
	function get_tutors_by_name($mysqli, $name)
	{		
		$result = $mysqli->query("SELECT DISTINCT tutor.'" . Tutor.TIDQueryString  ."', tutor.'" . Tutor.nameQueryString  ."', tutor.'" . Tutor.yearQueryString  ."', tutor.'" . Tutor.majorQueryString  ."', tutor.'" . Tutor.Room_NumberQueryString  ."', tutor.'" . Tutor.about_tutorQueryString  ."' FROM tutor WHERE tutor.'" . Tutor.nameQueryString  ."' LIKE '%" . $mysqli->real_escape_string($name) . "%' ORDER BY tutor.'" . Tutor.nameQueryString  ."'");
		$results_array = array();
		while($result_obj = $result->fetch_object("tutor"))
		{
			array_push($results_array, $result_obj);
		}	
		return $results_array;
	}
	
	function get_tutors_by_name_and_course($mysqli, $name, $course)
	{
		$result = $mysqli->query("SELECT DISTINCT tutor.'" . Tutor.TIDQueryString  ."', tutor.'" . Tutor.nameQueryString  ."', tutor.'" . Tutor.yearQueryString  ."', tutor.'" . Tutor.majorQueryString  ."', tutor.'" . Tutor.Room_NumberQueryString  ."', tutor.'" . Tutor.about_tutorQueryString  ."' FROM course INNER JOIN (tutor_course INNER JOIN tutor ON (tutor_course.'" . Tutor.TIDQueryString  ."'=tutor.'" . Tutor.TIDQueryString  ."')) ON (course.'" . Course.CIDQueryString  ."'=tutor_course.'" . Course.CIDQueryString  ."') WHERE tutor.'" . Tutor.nameQueryString  ."' LIKE '%"  . $mysqli->real_escape_string($name) ."%' AND course.'" . Course.course_numberQueryString  ."' LIKE '%" . $mysqli->real_escape_string($course) . "%'");
		$results_array = array();	
		while($result_obj = $result->fetch_object("tutor"))
		{
			array_push($results_array, $result_obj);
		}
		return $results_array;
	}
	
	function get_tutors_by_major($mysqli, $major)
	{
		$result = $mysqli->query("SELECT tutor.'" . Tutor.TIDQueryString  ."', tutor.'" . Tutor.nameQueryString  ."', tutor.'" . Tutor.yearQueryString  ."', tutor.'" . Tutor.majorQueryString  ."' FROM tutor WHERE tutor.'" . Tutor.majorQueryString  ."' = '%" . $mysqli->real_escape_string($major) . "%'");
		$results_array = array();
		while($result_obj = $result->fetch_object("tutor"))
		{
			array_push($results_array, $results_obj);
		}
		return $results_array;
	}
	
	function get_tutors_by_year($mysqli, $year)
	{
		$result = $mysqli->query("SELECT tutor.'" . Tutor.TIDQueryString  ."', tutor.name, tutor.'" . Tutor.yearQueryString  ."', tutor.'" . Tutor.majorQueryString  ."' FROM tutor WHERE tutor.'" . Tutor.yearQueryString  ."' = '" . $mysqli->real_escape_string($year) . "'");
		$results_array = array();
		while($result_obj = $result->fetch_object("tutor"))
		{
			array_push($results_array, $results_obj);
		}
		return $results_array;
	}
	
	function get_tutor_courses_tutored($mysqli, $tutor_id)
	{	
		$result = $mysqli->query("SELECT course.'" . Course.CIDQueryString  ."', course.'" . Course.departmentQueryString  ."', course.'" . Course.course_numberQueryString  ."', course.'" . Course.course_descriptionQueryString  ."' FROM course INNER JOIN tutor_course ON (course.'" . Course.CIDQueryString  ."' = tutor_course.'" . Course.CIDQueryString  ."' ) WHERE tutor_course.'" . Tutor.TIDQueryString  ."' = '" . $mysqli->real_escape_string($tutor_id) . "'");
		$results_array = array();
		while($results_obj = $result->fetch_object('Course'))
		{
			array_push($results_array, $results_obj);
		}
		return $results_array;
	}
	
	function get_tutor_timeslots_for_day($mysqli, $tutor_id, $day)
	{
		
		$result = $mysqli->query("SELECT timeslot.'" . tutor_timeslot.TSIDQueryString  ."', timeslot.'" . tutor_timeslot.TimeQueryString  ."',timeslot.'" . tutor_timeslot.PeriodQueryString  ."', tutor_timeslot.'" . tutor_timeslot.DAYOFWEEKQueryString  ."' FROM (timeslot INNER JOIN (tutor INNER JOIN tutor_timeslot ON tutor.'" . Tutor.TIDQueryString  ."' = tutor_timeslot.'" . Tutor.TIDQueryString  ."') ON (timeslot.'" . tutor_timeslot.TSIDQueryString  ."' =tutor_timeslot.'" . tutor_timeslot.TSIDQueryString  ."')) WHERE tutor.'" . Tutor.TIDQueryString  ."' = '" . $tutor_id . "' AND tutor_timeslot.'" . tutor_timeslot.DAYOFWEEKQueryString  ."' = '" . strtoupper($mysqli->real_escape_string($day)) . "'");
		$results_array = array();
		while($results_obj = $result->fetch_object('TutorTimeslot'))
		{
			array_push($results_array, $results_obj);
		}
		return $results_array;
	}
	
	function get_tutor_timeslots($mysqli, $tutor_id)
	{
		$result = $mysqli->query("SELECT timeslot.'" . tutor_timeslot.TSIDQueryString  ."', timeslot.'" . tutor_timeslot.TimeQueryString  ."',timeslot.'" . tutor_timeslot.PeriodQueryString  ."', tutor_timeslot.'" . tutor_timeslot.DAYOFWEEKQueryString  ."' FROM (timeslot INNER JOIN (tutor INNER JOIN tutor_timeslot ON tutor.'" . Tutor.TIDQueryString  ."' = tutor_timeslot.'" . Tutor.TIDQueryString  ."') ON (timeslot.'" . tutor_timeslot.TSIDQueryString  ."' =tutor_timeslot.'" . tutor_timeslot.TSIDQueryString  ."')) WHERE tutor.'" . Tutor.TIDQueryString  ."' = '" . $mysqli->real_escape_string($tutor_id) . "' ORDER BY tutor_timeslot.'" . tutor_timeslot.DAYOFWEEKQueryString  ."', timeslot.'" . tutor_timeslot.PeriodQueryString  ."', timeslot.'" . tutor_timeslot.TimeQueryString  ."'");
		$results_array = array();
		while($results_obj = $result->fetch_object('TutorTimeslot'))
		{
			array_push($results_array, $results_obj);
		}
		return $results_array;
	}
	
	function get_tutor_booked_timeslots($mysqli, $tutor_id, $date)
	{
		$result = $mysqli->query("SELECT '" . tutor_timeslot.TSIDQueryString  ."', tutee_uname  FROM booked_timeslots WHERE '" . Tutor.TIDQueryString  ."' = '". $mysqli->real_escape_string($tutor_id) ."' AND booked_day = '". $mysqli->real_escape_string($date) ."'" );
		
		return $result->fetch_all(MYSQLI_ASSOC);
	}
	
	function check_if_booked($mysqli,$tutor_id,$timeslot_id,$date)
	{
		$result = $mysqli->query("SELECT '" . Tutor.TIDQueryString  ."' FROM booked_timeslots WHERE '" . Tutor.TIDQueryString  ."' = '". $mysqli->real_escape_string($tutor_id) ."' AND booked_day = '". $mysqli->real_escape_string($date) ."' AND '" . tutor_timeslot.TSIDQueryString  ."' = '". $mysqli->real_escape_string($timeslot_id) ."'");
		
		return $result->fetch_all(MYSQLI_ASSOC);
	}
	
	function book_timeslot($mysqli, $tutor_id, $tutee_uname, $timeslot_id,$date)
	{
		$check = get_tutor_booked_timeslots($mysqli, $tutor_id,$date);

		if ($check) return NULL;
		
		$result = $mysqli->query("INSERT INTO booked_timeslots ('" . Tutor.TIDQueryString  ."','" . tutor_timeslot.TSIDQueryString  ."', tutee_uname, booked_day) VALUES ('". $tutor_id ."' , '". $mysqli->real_escape_string($timeslot_id) ."' , '". $mysqli->real_escape_string($tutee_uname) ."', '". $mysqli->real_escape_string($date) ."')");
		return $result;
	}

	function unbook_timeslot($mysqli, $tutor_id,$timeslot_id,$date)
	{	
		
		return $mysqli->query("DELETE FROM booked_timeslots WHERE '" . Tutor.TIDQueryString  ."' = '". $mysqli->real_escape_string($tutor_id) ."' AND '" . tutor_timeslot.TSIDQueryString  ."' = '". $mysqli->real_escape_string($timeslot_id) ."' AND booked_day = '". $mysqli->real_escape_string($date) ."'");
	}
	
	function get_timeslots($mysqli)
	{
		return $mysqli->query("SELECT '" . tutor_timeslot.TSIDQueryString  ."', '" . tutor_timeslot.TimeQueryString  ."', '" . tutor_timeslot.PeriodQueryString  ."' FROM timeslot")->fetch_all(MYSQLI_ASSOC);
	}
	
?>