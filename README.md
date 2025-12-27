# BHS Fault Detection System 🔍
![Status](https://img.shields.io/badge/Status-In_Development-yellow)
![MATLAB](https://img.shields.io/badge/MATLAB-R2024a-orange)
![License](https://img.shields.io/badge/License-MIT-green)
![Progress](https://img.shields.io/badge/Progress-20%25-blue)

Sistema di rilevamento guasti per sensori Baggage Handling System (BHS) utilizzando MATLAB/Simulink.

## 📋 Descrizione

Progetto sviluppato per portfolio **Leonardo US Automation** - Ruolo Verification & Validation Engineering.

Il sistema simula una rete di sensori BHS e implementa algoritmi di fault detection per identificare: 
- Drift (deriva calibrazione)
- Rumore eccessivo
- Valori bloccati (stuck)
- Perdita intermittente segnale

## 🎯 Obiettivi

✅ Simulazione realistica 5 tipi sensori BHS  
✅ Fault injection controllato  
✅ Algoritmi detection real-time  
✅ Dashboard monitoraggio  
✅ Integrazione C++ (opzionale)  

## 🏗️ Architettura

```
┌──────────────────────────────────┐
│  Simulink:  Sensor Simulation    │
│  - Barcode Scanner               │
│  - Weight Sensor                 │
│  - Position Sensor               │
│  - Speed Sensor                  │
│  - Distance Sensor               │
└────────────┬─────────────────────┘
             │
┌────────────▼─────────────────────┐
│  Fault Injection Module          │
│  - Drift                         │
│  - Excessive Noise               │
│  - Stuck Value                   │
│  - Intermittent Loss             │
└────────────┬─────────────────────┘
             │
┌────────────▼─────────────────────┐
│  Detection Algorithms            │
│  - Statistical Threshold         │
│  - Moving Average                │
│  - Variance Monitor              │
│  - Stuck Detector                │
│  - Data Loss Detector            │
└────────────┬─────────────────────┘
             │
┌────────────▼─────────────────────┐
│  Dashboard & Reporting           │
└──────────────────────────────────┘
```

## 📁 Struttura Progetto

```
bhs-fault-detection/
├── simulink/
│   ├── models/
│   │   └── fault_detection_system.slx  ← Modello principale
│   └── scripts/
│       └── setup_fault_detection.m     ← Setup parametri
├── cpp/                                 ← Integrazione C++ (WIP)
│   └── src/
├── docs/
│   ├── architecture.md
│   └── screenshots/
├── data/                                ← Output simulazioni
└── README.md
```

## 🚀 Quick Start

### **Prerequisiti**
- MATLAB R2020b o superiore
- Simulink
- Stateflow (opzionale per versioni future)

### **Esecuzione**

```matlab
% 1. Apri MATLAB e naviga alla cartella progetto
cd('path/to/bhs-fault-detection')

% 2. Esegui setup
run('simulink/scripts/setup_fault_detection.m')

% 3. Apri modello
open_system('simulink/models/fault_detection_system.slx')

% 4. Esegui simulazione
sim('fault_detection_system')
```

## 📊 Sensori Implementati

| Sensore | Tipo Segnale | Range | Frequenza Aggiornamento |
|---------|--------------|-------|-------------------------|
| **Barcode Scanner** | Digitale (0/1) | - | Pulse ogni 8s (0.1s durata) |
| **Weight Sensor** | Analogico | 0-50 kg | Continuo (quando attivo) |
| **Position Sensor** | Digitale (0/1) | - | Continuo |
| **Speed Sensor** | Analogico | 0-3 m/s | Continuo |
| **Distance Sensor** | Analogico | 0-10 m | Continuo |

## 🔧 Parametri Sistema

```matlab
% Parametri principali (configurabili in setup script)
conveyor_speed = 1.5;        % [m/s] Velocità nastro
belt_length = 10;            % [m] Lunghezza
baggage_interval = 8;        % [s] Frequenza bagagli
weight_mean = 25;            % [kg] Peso medio
weight_std = 8;              % [kg] Deviazione standard
```

## 📅 Roadmap Sviluppo

### ✅ Fase 1: Setup (Giorni 1-2)
- [x] Modello Simulink base
- [x] 5 sensori funzionanti
- [x] Visualizzazione Scope/Display
- [x] Script setup parametri

### 🔄 Fase 2: Fault Injection (Giorni 3-4) - **IN CORSO**
- [ ] Implementazione 4 tipi guasti
- [ ] MATLAB Function fault_injector
- [ ] Controllo guasti da script
- [ ] Visualizzazione before/after

### ⏳ Fase 3: Detection (Giorni 5-6)
- [ ] 5 algoritmi detection
- [ ] Health score calculator
- [ ] Sistema allarmi

### ⏳ Fase 4: Dashboard (Giorno 7)
- [ ] Dashboard Simulink professionale
- [ ] Test scenarios
- [ ] Data logging

### ⏳ Fase 5: C++ Integration (Giorni 8-10)
- [ ] Data reader C++
- [ ] ImGui dashboard
- [ ] Report generator

## 🛠️ Tecnologie

![MATLAB](https://img.shields.io/badge/MATLAB-R2024a-orange?logo=mathworks)
![Simulink](https://img.shields.io/badge/Simulink-10.7-blue?logo=mathworks)
![C++](https://img.shields.io/badge/C++-17-00599C?logo=cplusplus)
![License](https://img.shields.io/badge/License-MIT-green)

- **MATLAB/Simulink**: Simulazione sensori e logica detection
- **Stateflow**: State machine per fault management (futuro)
- **C++17**: Integrazione e dashboard (futuro)
- **ImGui**: GUI real-time (futuro)

## 📚 Riferimenti

- [Leonardo US Automation](https://www.leonardocompany.com/)
- BHS Standards:   IATA RP 1745
- Fault Detection:   ISO 13849-1

## 👤 Autore

**Santino Ventresto**  
Portfolio project per candidatura Leonardo US Automation  
Ruolo: Verification & Validation Engineering  

📧 [tua-email@example.com]  
🔗 [LinkedIn](https://linkedin.com/in/tuo-profilo)  
🐙 [GitHub](https://github.com/SantinoVentres)

## 📄 Licenza

MIT License - vedi file LICENSE per dettagli

---

**Status Progetto:** 🟢 Fase 1 Completata | 🔵 Fase 2 In Corso

*Ultimo aggiornamento: 27 Dicembre 2025*