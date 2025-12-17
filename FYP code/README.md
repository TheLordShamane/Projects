# Hybrid Edge-Cloud Face Recognition System

A comprehensive Final Year Project (FYP) demonstrating a hybrid edge-cloud architecture for AI-powered face recognition. This system deploys face detection and recognition models on edge devices (Arduino, Raspberry Pi) while leveraging a cloud backend for advanced processing, analytics, and user management.

## 📋 Project Overview

This project implements a distributed face recognition system with the following key components:

- **Edge Devices**: Arduino Nicla Vision and Raspberry Pi for real-time face detection and capture
- **Cloud Backend**: FastAPI server for face embedding extraction and recognition
- **Web Dashboard**: Next.js frontend for user management, analytics, and system monitoring
- **Model Optimization**: Experimental tools for model downsizing and quantization

### Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    Cloud Backend (FastAPI)                  │
│  - Face Recognition using InsightFace                       │
│  - MongoDB Database (User embeddings, metadata)             │
│  - Logging and Analytics                                    │
│  - Average Embedding Calculation                            │
└────────────────────┬────────────────────────────────────────┘
                     │
                     │ HTTP REST API
                     │
        ┌────────────┼────────────┐
        │            │            │
        ▼            ▼            ▼
   ┌────────┐  ┌────────┐  ┌──────────────┐
   │Arduino │  │RaspPi  │  │Next.js       │
   │Nicla   │  │  +     │  │Dashboard     │
   │Vision  │  │Camera  │  │Web UI        │
   │        │  │        │  │              │
   │(FOMO)  │  │(YOLO5) │  │              │
   └────────┘  └────────┘  └──────────────┘
   Face Detect  Face Detect   User Mgmt
   Local       Local          Analytics
```

## 🏗️ Project Structure

```
FYP code/
├── arduino-client/              # Arduino Nicla Vision micropython client
│   ├── app.py                  # Main Arduino application
│   └── README.md               # Setup & usage guide
├── backend-client/              # FastAPI backend server
│   ├── server.py               # Main server with face recognition endpoints
│   ├── requirements.txt         # Python dependencies
│   ├── .env                    # Environment configuration (MongoDB URI)
│   └── README.md               # API documentation
├── raspberry-pi-client/         # Raspberry Pi face detection client
│   ├── app.py                  # Main RPi application
│   ├── requirements.txt         # Python dependencies
│   └── README.md               # Setup & usage guide
├── frontend-client/             # Next.js web dashboard
│   ├── package.json            # Node dependencies
│   ├── next.config.js          # Next.js configuration
│   ├── middleware.js           # Request middleware
│   ├── tailwind.config.js      # Tailwind CSS config
│   ├── app/
│   │   ├── layout.js           # Root layout
│   │   ├── page.jsx            # Home page (redirects to dashboard)
│   │   ├── lib/                # Client-side utilities
│   │   │   ├── auth.js         # Authentication logic
│   │   │   ├── cloudApi.js     # API client for backend
│   │   │   ├── models.js       # MongoDB models
│   │   │   ├── data.js         # Data fetching utilities
│   │   │   └── utils.js        # Helper functions
│   │   ├── dashboard/          # Dashboard routes & pages
│   │   │   ├── users/          # User management
│   │   │   ├── models/         # AI models management
│   │   │   ├── analytics/      # Analytics (realtime, edge)
│   │   │   ├── embeddings/     # Face embeddings viewer
│   │   │   ├── people/         # People/Recognition results
│   │   │   ├── settings/       # System settings
│   │   │   └── help/           # Help & documentation
│   │   ├── login/              # Authentication pages
│   │   ├── register/
│   │   ├── reset-password/
│   │   ├── logout/
│   │   ├── api/                # Next.js API routes
│   │   │   └── auth/           # NextAuth configuration
│   │   ├── components/         # React components
│   │   └── contexts/           # React contexts
│   ├── ui/                     # UI component styles
│   └── public/                 # Static assets
├── downsizing-experimental-client/  # Model optimization research
│   ├── downsizing.ipynb        # Model quantization experiments
│   ├── onnx_to_tf.ipynb       # ONNX to TensorFlow conversion
│   ├── yolo5_face_demo.py     # YOLOv5 face detection demo
│   ├── models/                # Pre-trained ONNX models
│   ├── tflite_output/         # Quantized TFLite models
│   ├── calibration_images_v1/ # Calibration dataset v1
│   ├── calibration_images_v2/ # Calibration dataset v2
│   └── *.onnx                 # ONNX model files
├── FYP pics/                   # Project documentation images
└── README.md                   # This file
```

## 🔑 Key Features

### 1. **Edge Device Deployment**
- **Arduino Nicla Vision**: Lightweight FOMO (Faster Objects, More Objects) face detection model
- **Raspberry Pi**: Full-featured InsightFace detection with local preprocessing
- Both devices encode face crops in base64 and stream to the cloud backend

### 2. **Cloud Backend**
- **FastAPI Server** with the following endpoints:
  - `POST /recognize` - Accept face crops and return recognition results
  - `GET /metadata` - Fetch latest recognition metadata
  - `POST /calculate_average_embedding` - Batch process user embeddings
- **InsightFace Integration** for high-accuracy face embeddings (buffalo_sc model)
- **MongoDB** for persistent storage of user embeddings and metadata
- **Logging** of all recognition events to `logs.txt`

### 3. **Web Dashboard (Next.js)**
- **User Management**: Create/edit users and manage face embeddings
- **Real-time Analytics**: Live FPS, detection counts, and person identification
- **Embeddings Viewer**: Visualize and manage face embeddings
- **Authentication**: JWT-based login system
- **Responsive Design**: Built with Tailwind CSS

### 4. **Model Optimization**
- Experimental quantization and downsizing of YOLO11 and face detection models
- ONNX to TensorFlow conversion pipeline
- Support for dynamic and static quantization
- TFLite model generation for mobile/edge deployment

## 🚀 Quick Start

### Prerequisites
- Python 3.8+ (backend)
- Node.js 16+ (frontend)
- MongoDB Atlas or local MongoDB instance
- Arduino Nicla Vision board + OpenMV IDE (for Arduino)
- Raspberry Pi 4+ with camera module (for RPi)

### Backend Setup

1. **Navigate to backend directory**
   ```bash
   cd backend-client
   ```

2. **Create virtual environment**
   ```bash
   python -m venv .venv
   source .venv/bin/activate  # On Windows: .venv\Scripts\activate
   ```

3. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

4. **Configure environment**
   ```bash
   # Create .env file with:
   MONGO_URI=mongodb+srv://<username>:<password>@<cluster>/dashboard?retryWrites=true&w=majority
   ```

5. **Run server**
   ```bash
   python server.py
   # Server starts at http://localhost:8000
   ```

### Frontend Setup

1. **Navigate to frontend directory**
   ```bash
   cd frontend-client
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Create `.env.local`** with:
   ```bash
   NEXT_PUBLIC_API_BASE_URL=http://localhost:8000
   ```

4. **Run development server**
   ```bash
   npm run dev
   # Access at http://localhost:3000
   ```

### Arduino Nicla Vision Setup

1. **Download OpenMV IDE** from [openmv.io](https://openmv.io/)
2. **Flash Micropython** firmware to the board
3. **Upload [arduino-client/app.py](arduino-client/app.py)** to the device
4. **Configure WiFi credentials and server endpoint** in the script
5. **View detection results** in OpenMV IDE serial console

### Raspberry Pi Setup

1. **SSH into your Raspberry Pi**
   ```bash
   ssh pi@<your-pi-ip>
   ```

2. **Clone the project and navigate to client**
   ```bash
   cd raspberry-pi-client
   ```

3. **Create virtual environment and install dependencies**
   ```bash
   python3 -m venv .venv
   source .venv/bin/activate
   pip install -r requirements.txt
   ```

4. **Update server URL** in `app.py` to point to your backend
5. **Run the client**
   ```bash
   python app.py
   ```

## 📡 API Endpoints

### Backend FastAPI Server

#### `/recognize` (POST)
Receive face crops and return recognition results.

**Request:**
```json
{
  "fps": 15.2,
  "people_count": 2,
  "bboxes": [
    {
      "bbox": [x1, y1, x2, y2],
      "crop": "<base64-encoded-jpeg>"
    }
  ]
}
```

**Response:**
```json
{
  "status": "recognized",
  "meta": {
    "fps": 15.2,
    "people_count": 2,
    "bboxes": [
      {
        "bbox": [x1, y1, x2, y2],
        "crop": "<base64>",
        "name": "John Doe",
        "similarity": 0.89
      }
    ]
  }
}
```

#### `/metadata` (GET)
Fetch the latest recognition metadata.

**Response:** Latest metadata from the last `/recognize` call

#### `/calculate_average_embedding` (POST)
Process multiple images for a user and compute average face embedding.

**Request:** 
- Form data with `username` (string) and `files` (multiple image files)

**Response:**
```json
{
  "status": "success",
  "username": "john_doe",
  "embedding": [0.123, -0.456, ...],
  "images": 5
}
```

## 🧠 AI Models Used

### Face Detection
- **Arduino**: FOMO (64×64 input) - Lightweight, fast
- **Raspberry Pi**: InsightFace RetinaFace (320×320 input)
- **Backend**: InsightFace RetinaFace (320×320 input)

### Face Recognition
- **Backend**: InsightFace Buffalo SC - Pre-trained embedding extractor
  - Model: `buffalo_sc` (3.5MB)
  - Output: 512-dimensional normalized embedding
  - Similarity Threshold: 0.3 (configurable)

### Model Optimization (Experimental)
- **YOLO11N** → ONNX quantization
- **InsightFace ONNX** → TensorFlow/TFLite conversion
- Quantization Methods:
  - Static Int8 (v1, v2)
  - Dynamic Int8
  - Float16
  - Float32

## 📊 System Workflow

1. **Edge Device (Arduino/RPi)** captures video frames
2. **Local Detection** identifies faces in the frame
3. **Crop Extraction** and base64 encoding of face regions
4. **HTTP POST** to backend `/recognize` endpoint
5. **Backend Processing**:
   - Decode base64 face crops
   - Extract face embeddings using InsightFace
   - Compare against known embeddings in MongoDB
   - Return recognized names and similarity scores
6. **Frontend Dashboard** displays:
   - Real-time detection results
   - FPS and performance metrics
   - Person identification results
   - Analytics and historical data
7. **User Management** allows enrollment of new faces via web dashboard

## 🔐 Authentication & Security

- **NextAuth Integration**: OAuth/JWT-based authentication
- **MongoDB**: Encrypted connection via MongoDB Atlas
- **Environment Variables**: Sensitive data stored in `.env` files
- **CORS Enabled**: Configured for development; restrict in production

## 📈 Performance Optimization

- **Frame Skipping**: Process every N frames (configurable per 5 frames on RPi)
- **Resolution Downscaling**: Optional downscaling factor (1.5x on RPi)
- **Central Region Cropping**: Optional focus on center region
- **JPEG Compression**: Quality 25 on Arduino for minimal bandwidth
- **Model Quantization**: Reduced model sizes via Int8 quantization

## 🛠️ Configuration Files

### Backend `.env`
```dotenv
MONGO_URI=mongodb+srv://user:pass@cluster.mongodb.net/dashboard?retryWrites=true&w=majority
```

### Frontend `.env.local`
```bash
NEXT_PUBLIC_API_BASE_URL=http://localhost:8000
```

### Arduino Configuration (in app.py)
```python
SSID = "<WIFI-SSID>"
PASSWORD = "<WIFI-PASSWORD>"
SERVER_HOST = "<your-endpoint>"
SERVER_PORT = 8000
SERVER_PATH = "/recognize"
```

### Raspberry Pi Configuration (in app.py)
```python
SERVER_URL = "http://<server-ip>:8000/recognize"
MODEL_NAME = "buffalo_sc"
DET_SIZE = (320, 320)
DOWNSCALE_FACTOR = 1.5
PROCESS_EVERY_N = 5
```

## 📚 Component Documentation

For detailed setup and usage instructions, see:

- [Arduino Client Documentation](arduino-client/README.md)
- [Backend Server Documentation](backend-client/README.md)
- [Raspberry Pi Client Documentation](raspberry-pi-client/README.md)
- [Frontend Documentation](frontend-client/README.md)

## 🔍 Troubleshooting

### Backend Issues
- **MongoDB Connection Error**: Verify MONGO_URI in `.env`
- **InsightFace Model Not Found**: First run downloads model (~3.5MB)
- **Port Already in Use**: Change port in `uvicorn` run command

### Frontend Issues
- **API Connection Error**: Check `NEXT_PUBLIC_API_BASE_URL`
- **Authentication Failed**: Verify MongoDB connection from backend
- **Image Upload Fails**: Ensure backend `/calculate_average_embedding` endpoint is running

### Edge Device Issues
- **Arduino WiFi Connection**: Verify SSID/password, check router broadcasts 2.4GHz
- **Raspberry Pi FPS Low**: Increase `PROCESS_EVERY_N` or `DOWNSCALE_FACTOR`
- **Face Not Detected**: Adjust lighting, model confidence threshold, or detection size

## 📊 System Requirements

### Arduino Nicla Vision
- RAM: 640 KB
- Flash: 2 MB
- CPU: ARM Cortex M7 @ 200 MHz
- Connectivity: WiFi (2.4 GHz)

### Raspberry Pi
- Model: 4B or better
- RAM: 4 GB+
- Storage: 16 GB SD card+
- Connectivity: Ethernet or WiFi
- Camera: Raspberry Pi Camera Module v2+ or USB webcam

### Backend Server
- CPU: 2+ cores
- RAM: 4 GB+
- Storage: 50 GB+ (for MongoDB, logs, model cache)
- Connectivity: Public internet access or corporate VPN

### Frontend
- Any modern browser (Chrome, Firefox, Safari, Edge)
- Internet connectivity to backend

## 🧪 Experimental Features

The `downsizing-experimental-client` directory contains research code for model optimization:

- **Model Quantization**: Int8 static/dynamic, Float16, Float32 variants
- **ONNX Export**: YOLOv5 and face detection models in ONNX format
- **TensorFlow Conversion**: ONNX → TensorFlow → TFLite pipeline
- **Calibration Datasets**: Pre-prepared images for quantization calibration

These experiments support exploring deployment on ultra-constrained edge devices.

## 📝 License

This project is part of a Final Year Project (FYP) for educational purposes.

## 👥 Contributing

This is an academic project. For questions or improvements, please refer to project documentation.

## 📞 Support

For detailed component usage and troubleshooting:
1. Check individual component READMEs
2. Review configuration examples in this document
3. Check backend logs at `logs.txt`
4. Enable debug logging in frontend (check console)

---

**Last Updated**: June 2025
**Project Status**: InActive Development
