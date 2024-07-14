
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверитьЗаполениеТаблицыНачисления(Отказ);
	ПроверитьПериодыТаблицыНачисления(Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	СформироватьДвижения_ОсновныеНачисления();
	СформироватьДвижения_ДополнительныеНачисления_РассчитатьПроцентОтРабот();
	СформироватьДвижения_Удержания();
	
	РассчитатьОклад();
	РассчитатьОтпуск_СформироватьДвиженияОтпускаСотрудников();
	РассчитатьНДФЛ();
	
	СформироватьДвижения_ВзаиморасчетыССотрудниками();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПроверкаЗаполнения

Процедура ПроверитьЗаполениеТаблицыНачисления(Отказ)
	
	Если Начисления.Количество() = 0 Тогда
		ТекстСообщения = "Заполните документ ""Начисления зарплаты""";
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,"Объект.Начисления");
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьПериодыТаблицыНачисления(Отказ)
	
	МесяцДокумента = Месяц(Дата);
	ГодДокумента = Год(Дата);
	
	Для Каждого Строка Из Начисления Цикл
		
		Если Месяц(Строка.ДатаНачала) <> МесяцДокумента Тогда
			МесяцВТаблице = Формат(Строка.ДатаНачала,"ДФ=ММММ");
			МесяцРегистрации = НРег(Формат(Дата,"ДФ=ММММ"));
			ТекстСообщения = СтрШаблон("%1 месяц не соответствует месяцу документа (%2)", МесяцВТаблице, МесяцРегистрации);
			ПолеСообщения = СтрШаблон("Начисления[%1].ДатаНачала", Строка.НомерСтроки - 1);;
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, ПолеСообщения);
			Отказ = Истина;
		КонецЕсли;
		
		Если Год(Строка.ДатаНачала) <> ГодДокумента Тогда
			ГодВТаблице = Формат(Строка.ДатаНачала, "ДФ=гггг");
			ГодРегистрации = Формат(Дата, "ДФ=гггг");
			ТекстСообщения = СтрШаблон("%1 год не соответствует году документа (%2)", ГодВТаблице, ГодРегистрации);
			ПолеСообщения = СтрШаблон("Начисления[%1].ДатаНачала", Строка.НомерСтроки - 1);;
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, ПолеСообщения);
			Отказ = Истина;
		КонецЕсли;
		
		Если Месяц(Строка.ДатаОкончания) <> МесяцДокумента Тогда
			МесяцВТаблице = Формат(Строка.ДатаОкончания,"ДФ=ММММ");
			МесяцРегистрации = НРег(Формат(Дата,"ДФ=ММММ"));
			ТекстСообщения = СтрШаблон("%1 месяц не соответствует месяцу документа (%2)", МесяцВТаблице, МесяцРегистрации);
			ПолеСообщения = СтрШаблон("Начисления[%1].ДатаОкончания", Строка.НомерСтроки - 1);;
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, ПолеСообщения);
			Отказ = Истина;
		КонецЕсли;
		
		Если Год(Строка.ДатаОкончания) <> ГодДокумента Тогда
			ГодВТаблице = Формат(Строка.ДатаОкончания, "ДФ=гггг");
			ГодРегистрации = Формат(Дата, "ДФ=гггг");
			ТекстСообщения = СтрШаблон("%1 год не соответствует году документа (%2)", ГодВТаблице, ГодРегистрации);
			ПолеСообщения = СтрШаблон("Начисления[%1].ДатаОкончания", Строка.НомерСтроки - 1);;
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, ПолеСообщения);
			Отказ = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработкаПроведения

Процедура СформироватьДвижения_ОсновныеНачисления()
	
	ПериодРегистрации = НачалоМесяца(Дата);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВКМ_НачисленияЗарплатыНачисления.Сотрудник КАК Сотрудник,
		|	ВКМ_НачисленияЗарплатыНачисления.Сотрудник.Категория КАК Категория,
		|	ВКМ_НачисленияЗарплатыНачисления.ВидРасчета КАК ВидРасчета,
		|	ВКМ_НачисленияЗарплатыНачисления.ДатаНачала КАК ДатаНачала,
		|	ВКМ_НачисленияЗарплатыНачисления.ДатаОкончания КАК ДатаОкончания,
		|	ВКМ_НачисленияЗарплатыНачисления.ГрафикРаботы КАК ГрафикРаботы,
		|	ВКМ_НачисленияЗарплатыНачисления.ДатаНачала КАК ПериодДействияНачало,
		|	КОНЕЦПЕРИОДА(ВКМ_НачисленияЗарплатыНачисления.ДатаОкончания, ДЕНЬ) КАК ПериодДействияКонец
		|ИЗ
		|	Документ.ВКМ_НачисленияЗарплаты.Начисления КАК ВКМ_НачисленияЗарплатыНачисления
		|ГДЕ
		|	ВКМ_НачисленияЗарплатыНачисления.Ссылка = &Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	Сотрудник";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.ВидРасчета = ПланыВидовРасчета.ВКМ_ОсновныеНачисления.Оклад Тогда
			
			Движение = Движения.ВКМ_ОсновныеНачисления.Добавить();
			Движение.ПериодРегистрации = ПериодРегистрации;
			ЗаполнитьЗначенияСвойств(Движение, Выборка);
			
		КонецЕсли;
		
		Если Выборка.ВидРасчета = ПланыВидовРасчета.ВКМ_ОсновныеНачисления.Отпуск Тогда
			
			Движение = Движения.ВКМ_ОсновныеНачисления.Добавить();
			Движение.ПериодРегистрации = ПериодРегистрации;
			ЗаполнитьЗначенияСвойств(Движение, Выборка);
			Движение.БазовыйПериодНачало = НачалоМесяца(ДобавитьМесяц(ПериодРегистрации, -12));
			Движение.БазовыйПериодКонец = КонецМесяца(ДобавитьМесяц(ПериодРегистрации, -1));
			
		КонецЕсли;
		
	КонецЦикла;
	
	Движения.ВКМ_ОсновныеНачисления.Записать();
	
КонецПроцедуры

Процедура СформироватьДвижения_ДополнительныеНачисления_РассчитатьПроцентОтРабот()
	
	Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВКМ_НачисленияЗарплатыНачисления.Сотрудник КАК Сотрудник,
		|	ВКМ_НачисленияЗарплатыНачисления.Сотрудник.Категория КАК Категория,
		|	ЕСТЬNULL(ВКМ_ВыполненныеСотрудникомРаботыОбороты.ЧасовКОплатеОборот, 0) КАК ЧасовРаботы,
		|	ЕСТЬNULL(ВКМ_ВыполненныеСотрудникомРаботыОбороты.СуммаКОплатеОборот, 0) КАК СуммаКОплате
		|ИЗ
		|	Документ.ВКМ_НачисленияЗарплаты.Начисления КАК ВКМ_НачисленияЗарплатыНачисления
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ВКМ_ВыполненныеСотрудникомРаботы.Обороты(
		|				&НачалоПериода,
		|				&КонецПериода,
		|				Месяц,
		|				Сотрудник В
		|					(ВЫБРАТЬ
		|						ВКМ_НачисленияЗарплатыНачисления.Сотрудник КАК Сотрудник
		|					ИЗ
		|						Документ.ВКМ_НачисленияЗарплаты.Начисления КАК ВКМ_НачисленияЗарплатыНачисления
		|					ГДЕ
		|						ВКМ_НачисленияЗарплатыНачисления.Ссылка = &Ссылка
		|						И ВКМ_НачисленияЗарплатыНачисления.ВидРасчета = &Оклад)) КАК ВКМ_ВыполненныеСотрудникомРаботыОбороты
		|		ПО ВКМ_НачисленияЗарплатыНачисления.Сотрудник = ВКМ_ВыполненныеСотрудникомРаботыОбороты.Сотрудник
		|ГДЕ
		|	ВКМ_НачисленияЗарплатыНачисления.Ссылка = &Ссылка
		|	И ВКМ_НачисленияЗарплатыНачисления.ВидРасчета = &Оклад
		|
		|УПОРЯДОЧИТЬ ПО
		|	Сотрудник";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(Дата));
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(Дата));
	Запрос.УстановитьПараметр("Оклад", ПланыВидовРасчета.ВКМ_ОсновныеНачисления.Оклад);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			Если Выборка.Категория = Справочники.ВКМ_КатегорииСотрудников.Специалисты И Выборка.СуммаКОплате <> 0 Тогда
				
				Движение = Движения.ВКМ_ДополнительныеНачисления.Добавить();
				Движение.ПериодРегистрации = НачалоМесяца(Дата);
				Движение.Сотрудник = Выборка.Сотрудник;
				Движение.Категория = Выборка.Категория;
				Движение.ВидРасчета = ПланыВидовРасчета.ВКМ_ДополнительныеНачисления.ПроцентОтРабот;
				Движение.ЧасовРаботы = Выборка.ЧасовРаботы;
				Движение.Результат = Выборка.СуммаКОплате;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Движения.ВКМ_ДополнительныеНачисления.Записать();
	
КонецПроцедуры

Процедура СформироватьДвижения_Удержания()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВКМ_НачисленияЗарплатыНачисления.Сотрудник КАК Сотрудник,
	|	ВКМ_НачисленияЗарплатыНачисления.Сотрудник.Категория КАК СотрудникКатегория
	|ИЗ
	|	Документ.ВКМ_НачисленияЗарплаты.Начисления КАК ВКМ_НачисленияЗарплатыНачисления
	|ГДЕ
	|	ВКМ_НачисленияЗарплатыНачисления.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	Сотрудник";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Движение = Движения.ВКМ_Удержания.Добавить();
		Движение.ПериодРегистрации = НачалоМесяца(Дата);
		Движение.Сотрудник = Выборка.Сотрудник;
		Движение.Категория = Выборка.СотрудникКатегория;
		Движение.ВидРасчета = ПланыВидовРасчета.ВКМ_Удержания.НДФЛ;
		Движение.БазовыйПериодНачало = НачалоМесяца(Дата);
		Движение.БазовыйПериодКонец = КонецМесяца(Дата);
		
	КонецЦикла;
	
	Движения.ВКМ_Удержания.Записать();

КонецПроцедуры

Процедура РассчитатьОклад()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВКМ_ОсновныеНачисленияДанныеГрафика.НомерСтроки КАК НомерСтроки,
		|	ЕСТЬNULL(ВКМ_ОсновныеНачисленияДанныеГрафика.ЗначениеПериодДействия, 0) КАК КоличествоДнейПлан,
		|	ЕСТЬNULL(ВКМ_ОсновныеНачисленияДанныеГрафика.ЗначениеФактическийПериодДействия, 0) КАК КоличествоДнейФакт,
		|	ЕСТЬNULL(ВКМ_УсловияОплатыСотрудниковСрезПоследних.Оклад, 0) КАК Оклад
		|ИЗ
		|	РегистрРасчета.ВКМ_ОсновныеНачисления.ДанныеГрафика(
		|			Регистратор = &Ссылка
		|				И ВидРасчета = &Оклад) КАК ВКМ_ОсновныеНачисленияДанныеГрафика
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВКМ_УсловияОплатыСотрудников.СрезПоследних(
		|				&Период,
		|				Сотрудник В
		|					(ВЫБРАТЬ
		|						ВКМ_ОсновныеНачисления.Сотрудник КАК Сотрудник
		|					ИЗ
		|						РегистрРасчета.ВКМ_ОсновныеНачисления КАК ВКМ_ОсновныеНачисления
		|					ГДЕ
		|						ВКМ_ОсновныеНачисления.Регистратор = &Ссылка
		|						И ВКМ_ОсновныеНачисления.ВидРасчета = &Оклад)) КАК ВКМ_УсловияОплатыСотрудниковСрезПоследних
		|		ПО ВКМ_ОсновныеНачисленияДанныеГрафика.Сотрудник = ВКМ_УсловияОплатыСотрудниковСрезПоследних.Сотрудник";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Оклад", ПланыВидовРасчета.ВКМ_ОсновныеНачисления.Оклад);
	Запрос.УстановитьПараметр("Период", НачалоМесяца(Дата));
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Движение = Движения.ВКМ_ОсновныеНачисления[Выборка.НомерСтроки - 1];
		Движение.КоличествоДнейПлан = Выборка.КоличествоДнейПлан;
		Движение.КоличествоДнейФакт = Выборка.КоличествоДнейФакт;
		Движение.ПоказательОклада = Выборка.Оклад;
		
		Если Выборка.КоличествоДнейПлан = 0 Тогда
			Движение.Результат = 0;
		Иначе
			Движение.Результат = Выборка.Оклад / Выборка.КоличествоДнейПлан * Выборка.КоличествоДнейФакт;
		КонецЕсли;
		
	КонецЦикла;
	
	Движения.ВКМ_ОсновныеНачисления.Записать(, Истина);
	
КонецПроцедуры

Процедура РассчитатьОтпуск_СформироватьДвиженияОтпускаСотрудников()
	
	Движения.ВКМ_ОтпускаСотрудников.Записывать = Истина;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВКМ_ОсновныеНачисления.НомерСтроки КАК НомерСтроки,
	|	ЕСТЬNULL(ВКМ_ОсновныеНачисленияБазаВКМ_ОсновныеНачисления.РезультатБаза, 0) КАК РеультатБазаОсновные,
	|	ЕСТЬNULL(ВКМ_ОсновныеНачисленияБазаВКМ_ДополнительныеНачисления.РезультатБаза, 0) КАК РезультатБазаДополнительные,
	|	ЕСТЬNULL(ВКМ_ОсновныеНачисленияБазаВКМ_ОсновныеНачисления.КоличествоДнейПланБаза, 0) КАК КоличествоДнейПланБаза,
	|	ЕСТЬNULL(ВКМ_ОсновныеНачисленияДанныеГрафика.ЗначениеФактическийПериодДействия, 0) КАК КоличествоДнейФакт,
	|	РАЗНОСТЬДАТ(ВКМ_ОсновныеНачисления.ПериодДействияНачало, ДОБАВИТЬКДАТЕ(ВКМ_ОсновныеНачисления.ПериодДействияКонец, ДЕНЬ, 1), ДЕНЬ) КАК КоличествоДнейОтпуска
	|ИЗ
	|	РегистрРасчета.ВКМ_ОсновныеНачисления КАК ВКМ_ОсновныеНачисления
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрРасчета.ВКМ_ОсновныеНачисления.БазаВКМ_ОсновныеНачисления(
	|				&Измерение,
	|				&Измерение,
	|				,
	|				Регистратор = &Ссылка
	|					И ВидРасчета = &Отпуск) КАК ВКМ_ОсновныеНачисленияБазаВКМ_ОсновныеНачисления
	|		ПО ВКМ_ОсновныеНачисления.НомерСтроки = ВКМ_ОсновныеНачисленияБазаВКМ_ОсновныеНачисления.НомерСтроки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрРасчета.ВКМ_ОсновныеНачисления.БазаВКМ_ДополнительныеНачисления(
	|				&Измерение,
	|				&Измерение,
	|				,
	|				Регистратор = &Ссылка
	|					И ВидРасчета = &Отпуск) КАК ВКМ_ОсновныеНачисленияБазаВКМ_ДополнительныеНачисления
	|		ПО ВКМ_ОсновныеНачисления.НомерСтроки = ВКМ_ОсновныеНачисленияБазаВКМ_ДополнительныеНачисления.НомерСтроки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрРасчета.ВКМ_ОсновныеНачисления.ДанныеГрафика(
	|				Регистратор = &Ссылка
	|					И ВидРасчета = &Отпуск) КАК ВКМ_ОсновныеНачисленияДанныеГрафика
	|		ПО ВКМ_ОсновныеНачисления.НомерСтроки = ВКМ_ОсновныеНачисленияДанныеГрафика.НомерСтроки
	|ГДЕ
	|	ВКМ_ОсновныеНачисления.Регистратор = &Ссылка
	|	И ВКМ_ОсновныеНачисления.ВидРасчета = &Отпуск";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Отпуск", ПланыВидовРасчета.ВКМ_ОсновныеНачисления.Отпуск);
	
	Измерение = Новый Массив;
	Измерение.Добавить("Сотрудник");
	Запрос.УстановитьПараметр("Измерение", Измерение);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		//Регистр расчета "ВКМ_ОсновныеНачисления"
		ДвижениеОсновныеНачисления = Движения.ВКМ_ОсновныеНачисления[Выборка.НомерСтроки - 1];
		ДвижениеОсновныеНачисления.КоличествоДнейПлан = Выборка.КоличествоДнейПланБаза;
		ДвижениеОсновныеНачисления.КоличествоДнейФакт = Выборка.КоличествоДнейФакт;
		РезультатБазаОбщая = Выборка.РеультатБазаОсновные + Выборка.РезультатБазаДополнительные;
		ДвижениеОсновныеНачисления.ПоказательОклада = РезультатБазаОбщая;
		
		Если Выборка.КоличествоДнейПланБаза = 0 Тогда
			ДвижениеОсновныеНачисления.Результат = 0;
		Иначе
			ДвижениеОсновныеНачисления.Результат = РезультатБазаОбщая / Выборка.КоличествоДнейПланБаза * Выборка.КоличествоДнейФакт;
		КонецЕсли;
		
		//Регистр накопления "ВКМ_ОтпускаСотрудников"
		ДвижениеОтпуск = Движения.ВКМ_ОтпускаСотрудников.Добавить();
		ДвижениеОтпуск.Период = ДвижениеОсновныеНачисления.ПериодДействияНачало;
		ДвижениеОтпуск.Сотрудник = ДвижениеОсновныеНачисления.Сотрудник;
		ДвижениеОтпуск.КоличествоДнейФакт = Выборка.КоличествоДнейОтпуска;
		
	КонецЦикла;
	
	Движения.ВКМ_ОсновныеНачисления.Записать(, Истина);
	
КонецПроцедуры

Процедура РассчитатьНДФЛ()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВКМ_Удержания.НомерСтроки КАК НомерСтроки,
	|	ВКМ_Удержания.Сотрудник КАК Сотрудник,
	|	ВКМ_Удержания.Регистратор КАК Регистратор,
	|	ЕСТЬNULL(ВКМ_УдержанияБазаВКМ_ОсновныеНачисления.РезультатБаза, 0) КАК РезультатБазаОсновные
	|ПОМЕСТИТЬ ВТ_УдержанияОсновные
	|ИЗ
	|	РегистрРасчета.ВКМ_Удержания КАК ВКМ_Удержания
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрРасчета.ВКМ_Удержания.БазаВКМ_ОсновныеНачисления(
	|				&Измерение,
	|				&Измерение,
	|				,
	|				Регистратор = &Ссылка
	|					И ВидРасчета = &НДФЛ) КАК ВКМ_УдержанияБазаВКМ_ОсновныеНачисления
	|		ПО ВКМ_Удержания.НомерСтроки = ВКМ_УдержанияБазаВКМ_ОсновныеНачисления.НомерСтроки
	|ГДЕ
	|	ВКМ_Удержания.Регистратор = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_УдержанияОсновные.НомерСтроки КАК НомерСтроки,
	|	ВТ_УдержанияОсновные.РезультатБазаОсновные КАК РезультатБазаОсновные,
	|	ЕСТЬNULL(ВКМ_ДополнительныеНачисления.Результат, 0) КАК РезультатДополнительные
	|ИЗ
	|	ВТ_УдержанияОсновные КАК ВТ_УдержанияОсновные
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрРасчета.ВКМ_ДополнительныеНачисления КАК ВКМ_ДополнительныеНачисления
	|		ПО ВТ_УдержанияОсновные.Сотрудник = ВКМ_ДополнительныеНачисления.Сотрудник
	|			И ВТ_УдержанияОсновные.Регистратор = ВКМ_ДополнительныеНачисления.Регистратор";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("НДФЛ", ПланыВидовРасчета.ВКМ_Удержания.НДФЛ);
	
	Измерение = Новый Массив;
	Измерение.Добавить("Сотрудник");
	Запрос.УстановитьПараметр("Измерение", Измерение);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Движение = Движения.ВКМ_Удержания[Выборка.НомерСтроки - 1];
		ПроцентНДФЛ = 13;
		РезультатБазаОбщая = Выборка.РезультатБазаОсновные + Выборка.РезультатДополнительные;
		Движение.ПроцентНДФЛ = ПроцентНДФЛ;
		Движение.СовокупныйДоход = РезультатБазаОбщая;
		Движение.Результат = РезультатБазаОбщая * ПроцентНДФЛ / 100;
		
	КонецЦикла;
	
	Движения.ВКМ_Удержания.Записать();
	
КонецПроцедуры

Процедура СформироватьДвижения_ВзаиморасчетыССотрудниками()
	
	//Регистр накопления "Взаиморасчеты с сотрудниками"
	Движения.ВКМ_ВзаиморасчетыССотрудниками.Записывать = Истина;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВКМ_ОсновныеНачисления.Регистратор КАК Регистратор,
		|	ВКМ_ОсновныеНачисления.Сотрудник КАК Сотрудник,
		|	СУММА(ВКМ_ОсновныеНачисления.Результат) КАК РезультатОсновные
		|ПОМЕСТИТЬ ВТ_ОсновныеНачисления
		|ИЗ
		|	РегистрРасчета.ВКМ_ОсновныеНачисления КАК ВКМ_ОсновныеНачисления
		|ГДЕ
		|	ВКМ_ОсновныеНачисления.Регистратор = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	ВКМ_ОсновныеНачисления.Сотрудник,
		|	ВКМ_ОсновныеНачисления.Регистратор
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ОсновныеНачисления.Сотрудник КАК Сотрудник,
		|	ВТ_ОсновныеНачисления.РезультатОсновные КАК РезультатОсновные,
		|	ЕСТЬNULL(ВКМ_ДополнительныеНачисления.Результат, 0) КАК РезультатДополнительные,
		|	ЕСТЬNULL(ВКМ_Удержания.Результат, 0) КАК РезультатУдержания
		|ИЗ
		|	ВТ_ОсновныеНачисления КАК ВТ_ОсновныеНачисления
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрРасчета.ВКМ_ДополнительныеНачисления КАК ВКМ_ДополнительныеНачисления
		|		ПО ВТ_ОсновныеНачисления.Регистратор = ВКМ_ДополнительныеНачисления.Регистратор
		|			И ВТ_ОсновныеНачисления.Сотрудник = ВКМ_ДополнительныеНачисления.Сотрудник
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрРасчета.ВКМ_Удержания КАК ВКМ_Удержания
		|		ПО ВТ_ОсновныеНачисления.Регистратор = ВКМ_Удержания.Регистратор
		|			И ВТ_ОсновныеНачисления.Сотрудник = ВКМ_Удержания.Сотрудник";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Движение = Движения.ВКМ_ВзаиморасчетыССотрудниками.ДобавитьПриход();
		Движение.Период = НачалоМесяца(Дата);
		Движение.Сотрудник = Выборка.Сотрудник;
		РезультатОбщиеНачисления = Выборка.РезультатОсновные + Выборка.РезультатДополнительные;
		Движение.Сумма = РезультатОбщиеНачисления - Выборка.РезультатУдержания;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли

