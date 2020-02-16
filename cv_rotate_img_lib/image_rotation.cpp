#include "image_rotation.h"

#include <cmath>
#include <thread>

using namespace std;

namespace image_rotation
{

void rotate_image(const string& input_img_path, const string& output_img_path, const double& rot_angle_rad, const unsigned int& rotation_algorithm)
{
    // Read image with OpenCV
    Mat input_img;
    input_img = imread(input_img_path, CV_LOAD_IMAGE_COLOR);

    // Test image opening
    if(! input_img.data )
    {
        cout <<  "Could not open or find the img" << endl ;
        return;
    }

    const unsigned int img_height = input_img.rows;
    const unsigned int img_width = input_img.cols;

    // create Output image
    Mat output_img(img_height, img_width, CV_8UC3, Scalar(0, 0, 0));

    // Determining number of hardware thread contextes to use
    unsigned int nb_threads = thread::hardware_concurrency();
    if(nb_threads < 1)
    {
        nb_threads = 1;
    }

    // Launch nb_threads Threads
    vector<thread> v_threads;
    for(auto i = 0; i < nb_threads; ++i)
    {
        // call the specified rotation function
        switch(rotation_algorithm)
        {
            case 1:
                v_threads.push_back(thread(rotate_nearest_neighbor_interpolation, &input_img, &output_img, rot_angle_rad, i, nb_threads));
                break;
            case 2: 
                v_threads.push_back(thread(rotate_linear_interpolation, &input_img, &output_img, rot_angle_rad, i, nb_threads));
                break;
            case 3: 
                v_threads.push_back(thread(rotate_cubic_interpolation, &input_img, &output_img, rot_angle_rad, i, nb_threads));
                break;
        }
    }
        
    // Join Threads
    for(auto i = 0; i < nb_threads; ++i)
    {
        v_threads[i].join();
    }
    
    // Save the rotated image using OpenCv
    imwrite(output_img_path, output_img);
}

void rotate_nearest_neighbor_interpolation(const Mat* input_img, Mat* output_img, const double rot_angle_rad, const unsigned int thread_index, const unsigned int nb_threads)
{
    const unsigned int img_height = input_img->rows;
    const unsigned int img_width = input_img->cols;

    unsigned int rot_center[2];
    rot_center[0] = int(img_height / 2 + 1);
    rot_center[1] = int(img_width / 2 + 1);

    // pre-compute rotation operators
    const double cos_inv_rot = cos(-rot_angle_rad);
    const double sin_inv_rot = sin(-rot_angle_rad);
    
    const unsigned int nb_of_columns_to_process = floor(img_width / nb_threads);
    const unsigned int division_rest = img_width % nb_threads;

    // determine which pixels will be computed by the current Thread (image is divided by columns)
    const unsigned int j_start = thread_index * nb_of_columns_to_process;
    unsigned int j_end = j_start + nb_of_columns_to_process;
    if(thread_index == nb_threads-1)
    {
        j_end += division_rest;
    }
    
    // Loop over the pixel of the output image
    for(auto i = 0; i < img_height; ++i)
    {
        for(auto j = j_start; j < j_end; ++j)
        { 
            // compute "rotation center to current pixel" vector coordinates
            int pixel_center_vect[2];
            pixel_center_vect[0] = i - rot_center[0];
            pixel_center_vect[1] = j - rot_center[1];

            // compute the nearest pixel in the source img of the destination pixel ("inverse" rotation)
            int nearest_neighbor[2];
            nearest_neighbor[0] = rot_center[0] + pixel_center_vect[0] * cos_inv_rot + pixel_center_vect[1] * sin_inv_rot;
            nearest_neighbor[1] = rot_center[1] + pixel_center_vect[1] * cos_inv_rot - pixel_center_vect[0] * sin_inv_rot;

            // Only compute pixel color if origin pixel is inside image borders
            if(nearest_neighbor[0] >= 0 && nearest_neighbor[0] < img_height && nearest_neighbor[1] >= 0 && nearest_neighbor[1] < img_width)
            {
                // Get pixel color from origin pixel
                output_img->at<Vec3b>(i,j) = input_img->at<Vec3b>(nearest_neighbor[0],nearest_neighbor[1]);
            }
        }
    }

}

void rotate_linear_interpolation(const Mat* input_img, Mat* output_img, const double rot_angle_rad, const unsigned int thread_index, const unsigned int nb_threads)
{
    // Code here for linear interpolation function
}

void rotate_cubic_interpolation(const Mat* input_img, Mat* output_img, const double rot_angle_rad, const unsigned int thread_index, const unsigned int nb_threads)
{
    // Code here for cubic interpolation function
}

}
