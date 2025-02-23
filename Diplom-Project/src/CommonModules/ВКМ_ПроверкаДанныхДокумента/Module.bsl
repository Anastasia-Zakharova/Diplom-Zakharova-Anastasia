
#Область ПрограммныйИнтерфейс

// Получить данные договора.
// 
// Параметры:
//  ДатаДокумента - Дата - Дата документа
//  ДоговорСсылка - СправочникСсылка.ДоговорыКонтрагентов - Договор ссылка
// 
// Возвращаемое значение:
//  Структура -  Получить данные договора:
// * ЭтоАбонентскоеОбслуживание - Булево - 
// * ЭтоДействующийДоговор - Булево - 
Функция ПолучитьДанныеДоговора(ДатаДокумента, ДоговорСсылка) Экспорт
	
	// Проверка вида договора
	ДанныеДоговора = Новый Структура;
	
	//@skip-check wrong-string-literal-content
	ВидДоговора = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДоговорСсылка, "ВидДоговора");
	АбонентскоеОбслуживание = Перечисления.ВидыДоговоровКонтрагентов.ВКМ_АбонентскоеОбслуживание;
	
	Если ВидДоговора = АбонентскоеОбслуживание Тогда
		ДанныеДоговора.Вставить("ЭтоАбонентскоеОбслуживание", Истина);
	Иначе
		ДанныеДоговора.Вставить("ЭтоАбонентскоеОбслуживание", Ложь);
	КонецЕсли;
	
	// Проверка действия договора
	Выборка = ПолучитьДанные_ПериодДоговора(ДатаДокумента, ДоговорСсылка);
	
	Если Выборка.Следующий() Тогда
		ДанныеДоговора.Вставить("ЭтоДействующийДоговор", Истина);
	Иначе
		ДанныеДоговора.Вставить("ЭтоДействующийДоговор", Ложь);
	КонецЕсли;
	
	Возврат ДанныеДоговора;
	
КонецФункции

// Получить константы номенклатуры.
// 
// Возвращаемое значение:
//  Структура -  Получить константы номенклатуры:
// * ЕстьКонстантыНоменклатуры - Булево - 
Функция ПолучитьКонстантыНоменклатуры() Экспорт
	
	ДанныеКонстант = Новый Структура;
	
	// Проверка заполнения констант номенклатуры
	НоменклатураАбонентскаяПлата = ПолучитьНоменклатуруАбонентскаяПлата();
	НоменклатураРаботыСпециалиста = ПолучитьНоменклатуруРаботыСпециалиста();
	
	Если ЗначениеЗаполнено(НоменклатураАбонентскаяПлата) И ЗначениеЗаполнено(НоменклатураРаботыСпециалиста) Тогда
		ДанныеКонстант.Вставить("ЕстьКонстантыНоменклатуры", Истина);
		ДанныеКонстант.Вставить("НоменклатураАбонентскаяПлата", НоменклатураАбонентскаяПлата);
		ДанныеКонстант.Вставить("НоменклатураРаботыСпециалиста", НоменклатураРаботыСпециалиста);
	Иначе
		ДанныеКонстант.Вставить("ЕстьКонстантыНоменклатуры", Ложь)
	КонецЕсли;
	
	Возврат ДанныеКонстант;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ДанныеДоговора

Функция ПолучитьДанные_ПериодДоговора(ДатаДокумента, ДоговорСсылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДоговорыКонтрагентов.ВКМ_ДатаНачалаДействияДоговора КАК ДатаНачалаДействияДоговора,
	|	ДоговорыКонтрагентов.ВКМ_ДатаОкончанияДействияДоговора КАК ДатаОкончанияДействияДоговора
	|ИЗ
	|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	|ГДЕ
	|	ДоговорыКонтрагентов.Ссылка = &ДоговорСсылка
	|	И &ДатаДокумента МЕЖДУ ДоговорыКонтрагентов.ВКМ_ДатаНачалаДействияДоговора И ДоговорыКонтрагентов.ВКМ_ДатаОкончанияДействияДоговора";
	
	Запрос.УстановитьПараметр("ДоговорСсылка", ДоговорСсылка);
	Запрос.УстановитьПараметр("ДатаДокумента", ДатаДокумента);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Возврат Выборка;
	
КонецФункции

#КонецОбласти

#Область КонстантыНоменклатуры

Функция ПолучитьНоменклатуруАбонентскаяПлата()
	
	НоменклатураАбонентскаяПлата = Константы.ВКМ_НоменклатураАбонентскаяПлата.Получить();
	
	Возврат НоменклатураАбонентскаяПлата;
	
КонецФункции

Функция ПолучитьНоменклатуруРаботыСпециалиста()
	
	НоменклатураРаботыСпециалиста = Константы.ВКМ_НоменклатураРаботыСпециалиста.Получить();
	
	Возврат НоменклатураРаботыСпециалиста;
	
КонецФункции

#КонецОбласти

#КонецОбласти