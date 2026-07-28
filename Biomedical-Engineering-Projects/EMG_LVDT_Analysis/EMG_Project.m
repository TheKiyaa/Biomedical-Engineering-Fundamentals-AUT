%% پروژه دوم مقدمه‌ای بر مهندسی پزشکی - دکتر توحیدخواه
% پردازش سیگنال EMG و شبیه‌سازی سنسور LVDT
clear; clc; close all;

%% ==================== بخش اول: پردازش سیگنال EMG ====================
% الف) لود کردن و رسم سیگنال خام
fprintf('در حال بارگذاری سیگنال data_2...\n');
load('data_2.mat');
raw_emg = Data_EMG;
raw_emg = raw_emg(:); % تبدیل به یک بردار ستونی استاندارد
Fs = 1000; % فرکانس نمونه‌برداری بر اساس صورت پروژه (1000 هرتز)
N = length(raw_emg);
t = (0:N-1)/Fs; % ساخت محور زمان

% ایجاد شکل اول و ذخیره هندل آن
fig1 = figure('Name', 'بخش EMG - سیگنال خام و فیلتر شده');
subplot(2,1,1);
plot(t, raw_emg, 'b');
title('الف) سیگنال خام EMG (data\_2)');
xlabel('زمان (ثانیه)'); ylabel('دامنه (ولت)');
grid on;

% ب) طیف فرکانسی سیگنال خام با تبدیل فوریه
f_axis = (0:N-1)*(Fs/N); % محور فرکانس
Y_raw = fft(raw_emg);
P_raw = abs(Y_raw)/N; % طیف دوطرفه
P_raw_single = P_raw(1:floor(N/2)+1); % طیف یک‌طرفه
P_raw_single(2:end-1) = 2*P_raw_single(2:end-1);
f_axis_single = f_axis(1:floor(N/2)+1);

% ایجاد شکل دوم و ذخیره هندل آن
fig2 = figure('Name', 'بخش EMG - تحلیل فرکانسی');
subplot(2,1,1);
plot(f_axis_single, P_raw_single, 'b');
title('ب) طیف فرکانسی سیگنال خام EMG');
xlabel('فرکانس (هرتز)'); ylabel('دامنه');
xlim([0 500]); grid on;

% ج) طراحی فیلتر باترورث بالاگذر (فرکانس قطع 15 هرتز طبق صورت پروژه)
Wn_high = 15 / (Fs/2); % نرمالیزه کردن نسبت به فرکانس نایکوئیست
[b_high, a_high] = butter(5, Wn_high, 'high'); % مرتبه 5 طبق بلوک دیاگرام
filtered_emg = filter(b_high, a_high, raw_emg);

% رسم سیگنال فیلتر شده در شکل اول با استفاده از هندل
figure(fig1);
subplot(2,1,2);
plot(t, filtered_emg, 'r');
title('ج) سیگنال فیلتر شده EMG (بالاگذر 15 هرتز)');
xlabel('زمان (ثانیه)'); ylabel('دامنه (ولت)');
grid on;

% د) طیف فرکانسی سیگنال فیلتر شده
Y_filt = fft(filtered_emg);
P_filt = abs(Y_filt)/N;
P_filt_single = P_filt(1:floor(N/2)+1);
P_filt_single(2:end-1) = 2*P_filt_single(2:end-1);

% رسم طیف فرکانسی فیلتر شده در شکل دوم با استفاده از هندل
figure(fig2);
subplot(2,1,2);
plot(f_axis_single, P_filt_single, 'r');
title('د) طیف فرکانسی سیگنال فیلتر شده EMG');
xlabel('فرکانس (هرتز)'); ylabel('دامنه');
xlim([0 500]); grid on;

% ه) محاسبه پارامترهای آماری سیگنال فیلترشده
mean_filt = mean(filtered_emg);
median_filt = median(filtered_emg);
var_filt = var(filtered_emg);
std_filt = std(filtered_emg);
fprintf('\n--- پارامترهای آماری سیگنال فیلترشده (بخش ه) ---\n');
fprintf('میانگین: %f\n', mean_filt);
fprintf('میانه: %f\n', median_filt);
fprintf('واریانس: %f\n', var_filt);
fprintf('انحراف معیار: %f\n', std_filt);

% و و ز) استخراج پوش سیگنال با استفاده از تابع تعریف شده در انتهای کد
emg_envelope = extract_envelope(raw_emg, Fs);

figure('Name', 'بخش EMG - استخراج پوش سیگنال');
plot(t, raw_emg, 'Color', [0.7 0.7 0.7]); hold on;
plot(t, emg_envelope, 'r', 'LineWidth', 2);
title('ز) رسم پوش سیگنال روی سیگنال خام EMG');
xlabel('زمان (ثانیه)'); ylabel('دامنه (ولت)');
legend('سیگنال خام', 'پوش سیگنال (Envelope)');
grid on;

% ح) محاسبه پارامترهای آماری پوش سیگنال
mean_env = mean(emg_envelope);
median_env = median(emg_envelope);
var_env = var(emg_envelope);
std_env = std(emg_envelope);
fprintf('\n--- پارامترهای آماری پوش سیگنال (بخش ح) ---\n');
fprintf('میانگین: %f\n', mean_env);
fprintf('میانه: %f\n', median_env);
fprintf('واریانس: %f\n', var_env);
fprintf('انحراف معیار: %f\n', std_env);


%% ==================== توابع کمکی (Local Functions) ====================
function env = extract_envelope(signal, Fs)
    % این تابع پوش سیگنال را بر اساس بلوک دیاگرام پروژه استخراج می‌کند:
    % 1. فیلتر بالاگذر 15 هرتز باترورث مرتبه 5
    % 2. یکسوسازی (قدر مطلق)
    % 3. فیلتر پایین‌گذر 2 هرتز باترورث مرتبه 5
    
    % مرحله 1: فیلتر بالاگذر 15 هرتز
    Wn_h = 15 / (Fs/2);
    [b_h, a_h] = butter(5, Wn_h, 'high');
    hp_signal = filter(b_h, a_h, signal);
    
    % مرحله 2: یکسوسازی تمام موج (Full-wave Rectification)
    rect_signal = abs(hp_signal);
    
    % مرحله 3: فیلتر پایین‌گذر 2 هرتز برای استخراج پوش
    Wn_l = 2 / (Fs/2);
    [b_l, a_l] = butter(5, Wn_l, 'low');
    env = filter(b_l, a_l, rect_signal);
end

%% ==================== بخش دوم: شبیه سازی سنسور LVDT ====================

clearvars -except raw_emg filtered_emg emg_envelope
close all

%% الف) پارامترهای سنسور

k = 0.5;      % حساسیت سنسور (ولت بر میلی متر)

%% ب) رسم ولتاژ خروجی بر حسب جابجایی

x = -10:0.1:10;     % جابجایی هسته (میلی متر)

Vout = k*x;

figure('Name','LVDT - مشخصه انتقال');
plot(x,Vout,'LineWidth',2)
grid on

xlabel('جابجایی هسته x (mm)')
ylabel('ولتاژ خروجی V_{out} (V)')
title('ولتاژ خروجی بر حسب جابجایی هسته')

%% ج) شبیه سازی حرکت سینوسی هسته

A = 8;          % دامنه حرکت (میلی متر)
f = 0.5;        % فرکانس حرکت (Hz)

t = 0:0.001:10;

x_t = A*sin(2*pi*f*t);

Vout_t = k*x_t;

figure('Name','حرکت سینوسی هسته')

subplot(2,1,1)
plot(t,x_t,'LineWidth',1.5)
grid on
xlabel('زمان (s)')
ylabel('جابجایی (mm)')
title('جابجایی سینوسی هسته')

subplot(2,1,2)
plot(t,Vout_t,'LineWidth',1.5)
grid on
xlabel('زمان (s)')
ylabel('ولتاژ خروجی (V)')
title('ولتاژ خروجی سنسور LVDT')

%% د) بررسی ناحیه خطی

x_linear = -8:0.1:8;
V_linear = k*x_linear;

figure('Name','بررسی ناحیه خطی')

plot(x,Vout,'--','LineWidth',1)
hold on
plot(x_linear,V_linear,'LineWidth',3)

grid on
legend('کل محدوده','ناحیه خطی')
xlabel('جابجایی (mm)')
ylabel('ولتاژ خروجی (V)')
title('ناحیه خطی عملکرد سنسور LVDT')