#include "image_rotation.h"

using namespace std;

int main()
{
	// TEST INPUTS 1
	const string input_image_path =  "./input/th.jpeg";
	const string output_image_path =  "./output/th_output.jpeg";
	const double rotation_angle_rad = 10.*3.14/180.;
	// 1 : nearest neighbor interpolation
	// 2 : linear interpolation (not implemented)
	// 3 : cubic interpolation (not implemented)
	const unsigned int rotation_method = 1;

    image_rotation::rotate_image(input_image_path, output_image_path, rotation_angle_rad, rotation_method);


    // TEST INPUTS 2
	const string input_image_path_2 =  "./input/rose.jpeg";
	const string output_image_path_2 =  "./output/rose_output.jpeg";
	const double rotation_angle_rad_2 = -90.*3.14/180.;
	// 1 : nearest neighbor interpolation
	// 2 : linear interpolation (not implemented)
	// 3 : cubic interpolation (not implemented)
	const unsigned int rotation_method_2 = 1;

    image_rotation::rotate_image(input_image_path_2, output_image_path_2, rotation_angle_rad_2, rotation_method_2);


    // TEST INPUTS 3
	const string input_image_path_3 =  "./input/Android_robot.png";
	const string output_image_path_3 =  "./output/Android_robot_output.png";
	const double rotation_angle_rad_3 = 405.*3.14/180.;
	// 1 : nearest neighbor interpolation
	// 2 : linear interpolation (not implemented)
	// 3 : cubic interpolation (not implemented)
	const unsigned int rotation_method_3 = 1;

    image_rotation::rotate_image(input_image_path_3, output_image_path_3, rotation_angle_rad_3, rotation_method_3);


    // TEST INPUTS 4
	const string input_image_path_4 =  "./input/travel.jpg";
	const string output_image_path_4 =  "./output/travel_output.jpg";
	const double rotation_angle_rad_4 = 405.*3.14/180.;
	// 1 : nearest neighbor interpolation
	// 2 : linear interpolation (not implemented)
	// 3 : cubic interpolation (not implemented)
	const unsigned int rotation_method_4 = 1;

    image_rotation::rotate_image(input_image_path_4, output_image_path_4, rotation_angle_rad_4, rotation_method_4);


    return 0;
}
