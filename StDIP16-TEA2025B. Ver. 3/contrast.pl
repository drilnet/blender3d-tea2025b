
# Text: UTF-8 (RUS). Perl ver. 5.26. Program: contrast3(a). Version: 1.0.
# Author: (C) Demidov S.V.

	# Для объявления переменных.
	use strict;

	# В случае возникновений каких-либо проблем нужно остановить работу скрипта.
	use warnings FATAL => 'all';

	# Сообщаем, что символы в переменных могут быть в utf8.
	use utf8;

	# Все потоки STDIN, STDOUT, STDERR должны работать с utf8.
	use open qw(:std :utf8);

	# Модуль Encode.
	# Для перекодировки строк из внутреннего представления в utf-8
	# (или в другую кодировку).
	use Encode;

	#---
	# Начало измерения времени.
	use Time::HiRes qw(gettimeofday); 
	my $start_time = gettimeofday;
	#---

	# Какую контрастность установить.
	my $contrast = 10;

	my @filename_array; # Массив для имён файлов.
	my $catinimage;     # Каталог входящих изображений.
	my $catoutimage;    # Каталог исходящих изображений.
	my $null;           # Ненужный результат.
	my $countfile;      # Текущее значение счётчика без нулей.
	my $zerocf;         # Текущее значение счётчика с нулями слева (нумерация).
	my $filename;       # Текущий файл.
	my $newfilename;    # Новое название файла (с расширением).
	my $convert;        # Готовая команда для ImageMagick.

	my $elapsed_time;   # Затраченное время в $elapsed_time (в секундах).
	my $elapsed_sec;    # Затраченное время в секундах (4-ре знака после запятой).
	my $elapsed_min;    # Затраченное время в минутах (4-ре знака после запятой).
	my $elapsed_hour;   # Затраченное время в часах (4-ре знака после запятой).

	# Каталог входящих изображений.
	$catinimage = '100 frames animation (200x150px)/';
	# Каталог исходящих изображений.
	$catoutimage = '100 frames animation (200x150px), contrast/';

	print "\n";
	print "\n";
	print 'Сейчас все изображения в каталоге ' . '\'' . $catoutimage . '\' ';
	print 'будут перезаписаны!';
	print "\n";
	print 'Чтобы продолжить, нажмите "Enter"!';
	print "\n";
	print 'Чтобы выйти, ctrl+c!';
	print "\n";
	print "\n";
	$null = <STDIN>;

	opendir(DIRHANDLE, $catinimage) or die "Не могу открыть каталог $catinimage"; 

	print 'Чтение каталога ' . $catinimage . '... ';

	$countfile = 0;
	while ( defined ($filename = readdir(DIRHANDLE)) )
		{
		if ($filename ne '.' && $filename ne '..')
			{
			# Используем модуль Encode, без этого в $filename кракозябры...
			$filename = decode('utf8', $filename);

			# Имена файлов в массив.
			$filename_array[$countfile] = $filename;
			$countfile++;
			}
		}

	closedir(DIRHANDLE);

	print 'Готово!' . "\n";

	print 'Сортировка... ';
		# sort - Буквы верхнего регистра предшествуют всем
		# буквам нижнего регистра, а цифры предшествуют буквам.
		@filename_array = sort(@filename_array);
			print 'Готово!' . "\n";
				print "\n";

	print 'Всех файлов: ' . $countfile . '.';
	print "\n";
	print "\n";

	#
	# Основной цикл.
	#

	for ($countfile = 0; $countfile < @filename_array;)
		{
		$filename = $filename_array[$countfile];
		$countfile++;

		# Дополнить счетчик нулями слева.
		$zerocf = sprintf("%06d", $countfile);
		print $zerocf . '. ';

		print 'Файл: ' . $filename . ' ';

		# Новое название файлу (тоже самое).
		$newfilename = $filename;

		# Добавить контрастность.
		# +++
		$convert = "convert -quality 100 -brightness-contrast ";
		$convert.= "0/$contrast ";
		$convert.= "\'" . $catinimage . $filename . "\' ";
		$convert.= "\'" . $catoutimage . $newfilename . "\'";

		$null = `$convert`;

		print '=> Готово!';
		print "\n";
		}

	if ($countfile == 0)
		{
		print 'Внимание!' . "\n";
		print '---------' . "\n";
		print 'Во входящем каталоге ' . $catinimage . ' нет файлов...';
		}
		else
		{
		print "\n";

		# Конец измерения времени.
		my $end_time = gettimeofday;

		# Затраченное время в $elapsed_time.
		$elapsed_time = $end_time - $start_time;

		# '%.4f' - Оставить 4-ре знака после запятой.
		$elapsed_sec = sprintf('%.4f', $elapsed_time);
			$elapsed_min = sprintf('%.4f', $elapsed_time / 60);
				$elapsed_hour = sprintf('%.4f', $elapsed_time / 60 / 60);

		print 'Затраченное время: ';

		print $elapsed_sec . 'сек.';
			print ' ';
				print $elapsed_min . 'мин.';
					print ' ';
						print $elapsed_hour . 'час.';

		print "\n";
		print "\n";
		print 'Всё!';
		print "\n";
		print "\n";
		}
