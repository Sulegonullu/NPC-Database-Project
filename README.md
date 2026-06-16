# NPC Decision System Database

## Overview

This project models the decision-making behavior of NPCs (Non-Player Characters) in a dark fantasy game using a relational database architecture.

Instead of managing AI behavior directly in source code, NPC states, conditions, actions, and decision rules are stored and managed through Microsoft SQL Server.

This approach enables dynamic behavior management and improves flexibility, maintainability, and data integrity.

## Features

* Relational database design
* Normalized database architecture
* Entity Relationship (ER) modeling
* Stored Procedures
* User Defined Functions (UDF)
* Triggers
* Views
* Query optimization with indexes
* Analytical SQL queries

## Database Structure

The system consists of the following core entities:

* NPC
* States
* Conditions
* Actions
* Decisions
* Levels
* NPC_Level

These entities work together to determine NPC behavior under different game conditions.

## Technologies

* Microsoft SQL Server
* T-SQL
* Stored Procedures
* Functions
* Triggers
* Views
* Indexes

---

## Türkçe

### Proje Özeti

Bu proje, karanlık fantastik bir oyundaki NPC (Non-Player Character) karakterlerinin karar alma mekanizmalarını ilişkisel veritabanı mimarisi ile modellemek amacıyla geliştirilmiştir.

NPC durumları, koşulları, aksiyonları ve karar kuralları Microsoft SQL Server üzerinde tutulmaktadır.

### Özellikler

* İlişkisel veritabanı tasarımı
* Normalize edilmiş veritabanı yapısı
* ER diyagramı tasarımı
* Stored Procedure kullanımı
* User Defined Function (UDF)
* Trigger yapıları
* View kullanımı
* İndeksleme ve performans optimizasyonu
* Analitik SQL sorguları

### Kullanılan Teknolojiler

* Microsoft SQL Server
* T-SQL
* Stored Procedures
* Functions
* Triggers
* Views
* Indexes
