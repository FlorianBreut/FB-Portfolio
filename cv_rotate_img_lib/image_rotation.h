#ifndef IMAGE_ROTATION_H
#define IMAGE_ROTATION_H

#include <iostream>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>

using namespace std;
using namespace cv;

// Image rotation library functions definition
namespace image_rotation
{
	// Image Rotation function - This function calls specific rotation interpolation methods
	void rotate_image(const string& input_image_path, const string& output_image_path, const double& rotation_angle_rad, const unsigned int& rotation_algorithm);

    // Rotation - Nearest neighbor interpolation
	void rotate_nearest_neighbor_interpolation(const Mat* input_img, Mat* output_img, const double rot_angle_rad, const unsigned int thread_index, const unsigned int nb_threads);

	// Rotation - Linear interpolation
	void rotate_linear_interpolation(const Mat* input_img, Mat* output_img, const double rot_angle_rad, const unsigned int thread_index, const unsigned int nb_threads);

	// Rotation - Cubuc interpolation
	void rotate_cubic_interpolation(const Mat* input_img, Mat* output_img, const double rot_angle_rad, const unsigned int thread_index, const unsigned int nb_threads);
}

#endif // IMAGE_ROTATION_H
