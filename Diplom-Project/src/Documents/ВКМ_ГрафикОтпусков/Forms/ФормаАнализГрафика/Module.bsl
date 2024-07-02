
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьАнализОтпусков();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьАнализОтпусков()
	
	//@skip-check unknown-form-parameter-access
	СтруктураДанных = ПолучитьИзВременногоХранилища(Параметры.ДанныеПараметров);
	
	ЗаполнитьЗаголовокГрафикОтпусков(СтруктураДанных);
	
	ЗаполнитьДиаграммуГрафикОтпусков(СтруктураДанных);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЗаголовокГрафикОтпусков(СтруктураДанных)
	
	ГодГрафика = Формат(СтруктураДанных.Год, "ДФ=гггг");
	ЗаголовокАнализГрафика = СтрШаблон("График отпусков сотрудников в %1 году", ГодГрафика);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДиаграммуГрафикОтпусков(СтруктураДанных)
	
	ДиаграммаГрафикОтпусков.АвтоОпределениеПолногоИнтервала = Ложь;
	
	ГодДанных = Год(СтруктураДанных.Год);
	НачалоПериодаГрафика = Дата(ГодДанных, 1, 1);
	КонецПериодаГрафика = Дата(ГодДанных,12, 31);
	
	ДиаграммаГрафикОтпусков.УстановитьПолныйИнтервал(НачалоПериодаГрафика, КонецПериодаГрафика);
	
	ШкалаВремени = ДиаграммаГрафикОтпусков.ОбластьПостроения.ШкалаВремени.Элементы[0];
	ШкалаВремени.Единица = ТипЕдиницыШкалыВремени.Месяц;
	ШкалаВремени.Формат = "ДФ=ММММ";
	ШкалаВремени.ЦветФона = WEBЦвета.Лазурный;
	ШкалаВремени.ЦветТекста = WEBЦвета.ЦианНейтральный;
	
	ДиаграммаГрафикОтпусков.ОтображатьЛегенду = Ложь;
	
	ДиаграммаГрафикОтпусков.Очистить();
	
	Серия = ДиаграммаГрафикОтпусков.УстановитьСерию("Отпуск");
	
	ТаблицаОтпускаСотрудников = СтруктураДанных.ТаблицаОтпускаСотрудников;
	
	Для Каждого Строка Из ТаблицаОтпускаСотрудников Цикл
		
		Точка = ДиаграммаГрафикОтпусков.УстановитьТочку(Строка.Сотрудник);
		
		Значение = ДиаграммаГрафикОтпусков.ПолучитьЗначение(Точка, Серия);
		
		Интервал = Значение.Добавить();
		Интервал.Начало = Строка.ДатаНачала;
		Интервал.Конец = Строка.ДатаОкончания;
		
		Если Строка.КоличествоДней > 28 Тогда
			Точка.Картинка = БиблиотекаКартинок.ВКМ_КартинкаОтпуск;
			Интервал.Цвет = WEBЦвета.Красный;
		Иначе
			Точка.Картинка = БиблиотекаКартинок.ВКМ_КартинкаСотрудник;
			Интервал.Цвет = WEBЦвета.НасыщенноНебесноГолубой;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

