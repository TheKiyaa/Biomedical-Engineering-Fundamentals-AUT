# Biomedical-Engineering-Fundamentals-AUT
A collection of MATLAB-based bioelectrical projects covering cardiovascular hemodynamic modeling, EMG signal processing, and MRI tumor segmentation, developed at Amirkabir University of Technology (AUT).

# Fundamentals of Biomedical Engineering - Projects

This repository contains a collection of computational projects developed during the Introduction to Biomedical Engineering course at Amirkabir University of Technology. The projects focus on physiological modeling, biological signal processing, and medical image analysis using MATLAB.

## 📂 Repository Structure

### 1. Cardiovascular Hemodynamic Modeling (Windkessel Model)
This project focuses on the mathematical and systemic lumped-parameter modeling of human blood circulation hemodynamics. 
*   **Key Features:** 
    *   Simulated the effects of body posture (lying down vs. standing) and hydrostatic pressure on brain and foot blood pressure[cite: 1, 2].
    *   Analyzed the impact of heart rate variations (tachycardia and bradycardia)[cite: 1].
    *   Modeled physiological conditions such as peripheral vasoconstriction and arteriosclerosis (reduced vascular compliance due to aging)[cite: 1].
*   **Technologies:** MATLAB, Differential Equations, Circuit Analysis[cite: 1, 2].

### 2. Biological Signal Processing (EMG) & LVDT Sensor Simulation
This section is divided into two main bio-instrumentation topics:
*   **EMG Processing:** Applied Fast Fourier Transform (FFT) for frequency analysis and implemented a 4th-order Butterworth bandpass filter (10-400 Hz) to remove noise and motion artifacts from raw surface EMG signals. Extracted the signal envelope using full-wave rectification and low-pass filtering to evaluate muscle contraction patterns[cite: 3, 4].
*   **LVDT Simulation:** Simulated the static linear characteristics and dynamic sinusoidal core movement of a Linear Variable Differential Transformer (LVDT) displacement sensor, analyzing its linear operational range for medical device applications[cite: 3, 4].
*   **Technologies:** MATLAB, Digital Signal Processing (DSP), Bio-sensors[cite: 3, 4].

### 3. MRI Brain Tumor Segmentation
This project demonstrates foundational medical image processing techniques applied to 3D NIfTI brain MRI scans.
*   **Key Features:**
    *   Loaded and pre-processed NIfTI images, including Min-Max normalization and cropping[cite: 5].
    *   Applied a Bilateral Filter to significantly reduce image noise while preserving critical edges[cite: 5].
    *   Conducted histogram analysis to perform threshold-based segmentation, successfully isolating the background, healthy brain tissue, and tumor regions[cite: 5].
*   **Technologies:** MATLAB, Medical Image Processing, Computer Vision[cite: 5].

## 🛠️ Prerequisites
* MATLAB (Signal Processing Toolbox, Image Processing Toolbox)

## 👤 Author
**Mohammadkia Ghasemi** 
Undergraduate Student in Biomedical Engineering
