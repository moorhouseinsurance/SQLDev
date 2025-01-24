<?xml version="1.0" encoding="utf-8"?>
<screen name="frmCInfo.tst" type="NextPrevious">
    <backColor>
        <r>212</r>
        <g>208</g>
        <b>200</b>
    </backColor>
    <boundScreen />
    <caption>Client Information / Cover</caption>
    <description>Client Information / Cover</description>
    <screenType>0</screenType>
    <projectType>1</projectType>
    <postQuoteNavigationDuplicated>False</postQuoteNavigationDuplicated>
    <foreColor>
        <r>0</r>
        <g>0</g>
        <b>0</b>
    </foreColor>
    <height>864</height>
    <parentID />
    <text>Liability: Client Information / Cover</text>
    <width>912</width>
    <defaultFont>
        <bold>False</bold>
        <fontName>Tahoma</fontName>
        <formLoadCode />
        <formValidateCode />
        <italic>False</italic>
        <size>8.25</size>
        <strikeout>False</strikeout>
        <underline>False</underline>
    </defaultFont>
    <controls>
        <control name="grpTempEmps" type="GroupBox">
            <backColor>
                <r>212</r>
                <g>208</g>
                <b>200</b>
            </backColor>
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>80</height>
            <left>445</left>
            <font>
                <bold>True</bold>
                <fontName>Tahoma</fontName>
                <italic>False</italic>
                <size>8.25</size>
                <strikeout>False</strikeout>
                <underline>False</underline>
            </font>
            <rightToLeft>0</rightToLeft>
            <tabIndex>29</tabIndex>
            <text>Temporary Employees Insurance</text>
            <top>10</top>
            <width>444</width>
            <controls>
                <control name="txtManDays" type="WisTextBox">
                    <LostFocusCode />
                    <GotFocusCode />
                    <ClickCode />
                    <TextChangedCode />
                    <enableControls />
                    <sumTotalControls />
                    <acceptsTab>False</acceptsTab>
                    <acceptsReturn>False</acceptsReturn>
                    <backColor>
                        <r>255</r>
                        <g>255</g>
                        <b>255</b>
                    </backColor>
                    <borderStyle>1</borderStyle>
                    <boundScreen />
                    <characterCasing>0</characterCasing>
                    <columnName>MANDAYS</columnName>
                    <description>How many man days per year?</description>
                    <decimalPlaces>0</decimalPlaces>
                    <useDecimalPlaces>False</useDecimalPlaces>
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>21</height>
                    <left>345</left>
                    <font>
                        <bold>False</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <linkedData />
                    <maxLength>3</maxLength>
                    <multiLine>False</multiLine>
                    <numeric>True</numeric>
                    <autoIncrement>False</autoIncrement>
                    <maxAutoValue>0</maxAutoValue>
                    <properCase>False</properCase>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>31</tabIndex>
                    <text />
                    <textAlign>0</textAlign>
                    <top>49</top>
                    <width>93</width>
                    <showData />
                    <objectID>0</objectID>
                    <longPropertyID>0</longPropertyID>
                    <defaultValue />
                    <showHelpText>True</showHelpText>
                    <helpText>A man day is one day's work by one person. Please calculate the appropriate number of man days for a year. As an example, if you have 10 temporary employees that will be working for 10 days, you will require cover for 100 man days.</helpText>
                    <required>True</required>
                    <displayOnWebpage>True</displayOnWebpage>
                    <alwaysVisible>False</alwaysVisible>
                    <startYear />
                    <endYear />
                    <controls />
                </control>
                <control name="WisLabel29" type="WisLabel">
                    <sumTotalControls />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <boundTransform />
                    <description>txtManDays</description>
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>23</height>
                    <left>9</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>0</tabIndex>
                    <text>How many man days per year?</text>
                    <textAlign>1</textAlign>
                    <top>49</top>
                    <width>192</width>
                    <isDateDiff>0</isDateDiff>
                    <maskedEditBox />
                    <maskedEditBox2 />
                    <showData />
                    <controls />
                </control>
                <control name="optTempInsurance" type="tgsYesNo">
                    <LostFocusCode />
                    <GotFocusCode />
                    <ClickCode />
                    <enableControls>
                        <enableControl>
                            <boundScreen>MLIAB\frmCInfo.tst</boundScreen>
                            <control>txtManDays</control>
                            <enable>True</enable>
                        </enableControl>
                        <enableControl>
                            <boundScreen>MLIAB\frmCInfo.tst</boundScreen>
                            <control>WisLabel29</control>
                            <enable>True</enable>
                        </enableControl>
                        <enableControl>
                            <boundScreen>MLIAB\frmCInfo.tst</boundScreen>
                            <control>grpERN</control>
                            <enable>True</enable>
                        </enableControl>
                    </enableControls>
                    <displayPages />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <columnName>TEMPINSURANCE</columnName>
                    <description>Do you require temporary employees insurance?</description>
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>27</height>
                    <left>345</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <linkedData />
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>30</tabIndex>
                    <text />
                    <top>16</top>
                    <width>93</width>
                    <showData />
                    <objectID>0</objectID>
                    <longPropertyID>0</longPropertyID>
                    <defaultValue />
                    <showHelpText>True</showHelpText>
                    <helpText>This is for employees that are working on a short-term basis for you and are not on a permanent contract of employment.</helpText>
                    <required>True</required>
                    <displayOnWebpage>True</displayOnWebpage>
                    <alwaysVisible>False</alwaysVisible>
                    <controls />
                </control>
                <control name="WisLabel28" type="WisLabel">
                    <sumTotalControls />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <boundTransform />
                    <description>optTempInsurance</description>
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>27</height>
                    <left>9</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>0</tabIndex>
                    <text>Do you require temporary employees insurance?</text>
                    <textAlign>16</textAlign>
                    <top>16</top>
                    <width>291</width>
                    <isDateDiff>0</isDateDiff>
                    <maskedEditBox />
                    <maskedEditBox2 />
                    <showData />
                    <controls />
                </control>
            </controls>
        </control>
        <control name="grpHistory" type="GroupBox">
            <backColor>
                <r>212</r>
                <g>208</g>
                <b>200</b>
            </backColor>
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>127</height>
            <left>445</left>
            <font>
                <bold>True</bold>
                <fontName>Tahoma</fontName>
                <italic>False</italic>
                <size>8.25</size>
                <strikeout>False</strikeout>
                <underline>False</underline>
            </font>
            <rightToLeft>0</rightToLeft>
            <tabIndex>32</tabIndex>
            <text />
            <top>96</top>
            <width>444</width>
            <controls>
                <control name="cfdBonaFideWR" type="tgsCurrencyField">
                    <LostFocusCode />
                    <GotFocusCode />
                    <ClickCode />
                    <TextChangedCode />
                    <ValueChangedCode />
                    <enableControls />
                    <sumTotalControls />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <columnName>BONAFIDEWR</columnName>
                    <codeEnabled>False</codeEnabled>
                    <description>Bona Fide Wageroll  (Supply and Fix)</description>
                    <decimalPlaces>0</decimalPlaces>
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <editable>True</editable>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>21</height>
                    <left>323</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <rightToLeft>0</rightToLeft>
                    <symbolEnabled>True</symbolEnabled>
                    <tabIndex>37</tabIndex>
                    <text />
                    <top>96</top>
                    <width>115</width>
                    <sumInsured>False</sumInsured>
                    <showData />
                    <objectID>0</objectID>
                    <longPropertyID>0</longPropertyID>
                    <defaultValue />
                    <showHelpText>True</showHelpText>
                    <helpText>Bona fide sub-contractors are individuals or firms who supply their own labour, tools and materials and work without supervision by the main contractor. Please put 0 if this does not apply to you.</helpText>
                    <required>True</required>
                    <displayOnWebpage>True</displayOnWebpage>
                    <alwaysVisible>False</alwaysVisible>
                    <controls />
                </control>
                <control name="WisLabel10" type="WisLabel">
                    <sumTotalControls />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <boundTransform />
                    <description>txtYrEstablished</description>
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>23</height>
                    <left>9</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>0</tabIndex>
                    <text>What year were you established?</text>
                    <textAlign>1</textAlign>
                    <top>17</top>
                    <width>209</width>
                    <isDateDiff>0</isDateDiff>
                    <maskedEditBox />
                    <maskedEditBox2 />
                    <showData />
                    <controls />
                </control>
                <control name="WisLabel14" type="WisLabel">
                    <sumTotalControls />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <boundTransform />
                    <description>cfdBonaFideWR</description>
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>23</height>
                    <left>9</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>0</tabIndex>
                    <text>Bona Fide Wageroll  (Supply and Fix)</text>
                    <textAlign>16</textAlign>
                    <top>96</top>
                    <width>220</width>
                    <isDateDiff>0</isDateDiff>
                    <maskedEditBox />
                    <maskedEditBox2 />
                    <showData />
                    <controls />
                </control>
                <control name="txtYrEstablished" type="WisTextBox">
                    <LostFocusCode />
                    <GotFocusCode />
                    <ClickCode />
                    <TextChangedCode />
                    <enableControls />
                    <sumTotalControls />
                    <acceptsTab>False</acceptsTab>
                    <acceptsReturn>False</acceptsReturn>
                    <backColor>
                        <r>255</r>
                        <g>255</g>
                        <b>255</b>
                    </backColor>
                    <borderStyle>1</borderStyle>
                    <boundScreen />
                    <characterCasing>0</characterCasing>
                    <columnName>YRESTABLISHED</columnName>
                    <description>What year were you established?</description>
                    <decimalPlaces>0</decimalPlaces>
                    <useDecimalPlaces>False</useDecimalPlaces>
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>21</height>
                    <left>348</left>
                    <font>
                        <bold>False</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <linkedData />
                    <maxLength>4</maxLength>
                    <multiLine>False</multiLine>
                    <numeric>True</numeric>
                    <autoIncrement>False</autoIncrement>
                    <maxAutoValue>0</maxAutoValue>
                    <properCase>False</properCase>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>32</tabIndex>
                    <text />
                    <textAlign>0</textAlign>
                    <top>15</top>
                    <width>42</width>
                    <showData />
                    <objectID>0</objectID>
                    <longPropertyID>0</longPropertyID>
                    <defaultValue />
                    <showHelpText>True</showHelpText>
                    <helpText>Please enter the year in which you started trading in the format YYYY e.g. 2001.</helpText>
                    <required>True</required>
                    <displayOnWebpage>True</displayOnWebpage>
                    <alwaysVisible>False</alwaysVisible>
                    <startYear />
                    <endYear />
                    <controls />
                </control>
                <control name="cfdAnnualTurnover" type="tgsCurrencyField">
                    <LostFocusCode />
                    <GotFocusCode />
                    <ClickCode />
                    <TextChangedCode />
                    <ValueChangedCode />
                    <enableControls />
                    <sumTotalControls />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <columnName>ANNUALTURNOVER</columnName>
                    <codeEnabled>False</codeEnabled>
                    <description>What is your Estimated Annual Turnover?</description>
                    <decimalPlaces>0</decimalPlaces>
                    <maximumTotal />
                    <minimumTotal />
                    <enabled>True</enabled>
                    <editable>True</editable>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>21</height>
                    <left>323</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <rightToLeft>0</rightToLeft>
                    <symbolEnabled>True</symbolEnabled>
                    <tabIndex>36</tabIndex>
                    <text />
                    <top>69</top>
                    <width>115</width>
                    <sumInsured>False</sumInsured>
                    <showData />
                    <objectID>0</objectID>
                    <longPropertyID>0</longPropertyID>
                    <defaultValue />
                    <showHelpText>True</showHelpText>
                    <helpText>Please enter your annual turnover here as a number. Do not include any £ signs or commas. If your turnover is £100,000, please type 100000. if you are a new business, please enter your estimated turnover for your first year.</helpText>
                    <required>True</required>
                    <displayOnWebpage>True</displayOnWebpage>
                    <alwaysVisible>False</alwaysVisible>
                    <controls />
                </control>
                <control name="txtyrs" type="WisTextBox">
                    <LostFocusCode />
                    <GotFocusCode />
                    <ClickCode />
                    <TextChangedCode />
                    <enableControls>
                        <enableControl>
                            <boundScreen>MLIAB\frmCInfo.tst</boundScreen>
                            <control>txtYrsExp</control>
                            <enable>True</enable>
                            <symbol>Less</symbol>
                            <threshold>3</threshold>
                        </enableControl>
                        <enableControl>
                            <boundScreen>MLIAB\frmCInfo.tst</boundScreen>
                            <control>lblYrsExpQuestion</control>
                            <enable>True</enable>
                            <symbol>Less</symbol>
                            <threshold>3</threshold>
                        </enableControl>
                    </enableControls>
                    <sumTotalControls />
                    <acceptsTab>False</acceptsTab>
                    <acceptsReturn>False</acceptsReturn>
                    <backColor>
                        <r>240</r>
                        <g>240</g>
                        <b>240</b>
                    </backColor>
                    <borderStyle>1</borderStyle>
                    <boundScreen />
                    <characterCasing>0</characterCasing>
                    <columnName>YRS</columnName>
                    <description>How many years have you been established?</description>
                    <decimalPlaces>0</decimalPlaces>
                    <useDecimalPlaces>False</useDecimalPlaces>
                    <maximumTotal>500</maximumTotal>
                    <minimumTotal>0</minimumTotal>
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>21</height>
                    <left>396</left>
                    <font>
                        <bold>False</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <linkedData />
                    <maxLength>2</maxLength>
                    <multiLine>False</multiLine>
                    <numeric>True</numeric>
                    <autoIncrement>False</autoIncrement>
                    <maxAutoValue>0</maxAutoValue>
                    <properCase>False</properCase>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>34</tabIndex>
                    <text />
                    <textAlign>0</textAlign>
                    <top>15</top>
                    <width>18</width>
                    <showData />
                    <objectID>0</objectID>
                    <longPropertyID>0</longPropertyID>
                    <defaultValue />
                    <showHelpText>False</showHelpText>
                    <helpText />
                    <required>True</required>
                    <displayOnWebpage>True</displayOnWebpage>
                    <alwaysVisible>False</alwaysVisible>
                    <startYear>frmCInfo.YRESTABLISHED</startYear>
                    <endYear>System.Date</endYear>
                    <controls />
                </control>
                <control name="WisLabel13" type="WisLabel">
                    <sumTotalControls />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <boundTransform />
                    <description>cfdAnnualTurnover</description>
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>23</height>
                    <left>9</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>0</tabIndex>
                    <text>What is your Estimated Annual Turnover?</text>
                    <textAlign>16</textAlign>
                    <top>69</top>
                    <width>246</width>
                    <isDateDiff>0</isDateDiff>
                    <maskedEditBox />
                    <maskedEditBox2 />
                    <showData />
                    <controls />
                </control>
                <control name="WisLabel11" type="WisLabel">
                    <sumTotalControls />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <boundTransform />
                    <description />
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>23</height>
                    <left>417</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>18</tabIndex>
                    <text>yrs</text>
                    <textAlign>1</textAlign>
                    <top>17</top>
                    <width>21</width>
                    <isDateDiff>0</isDateDiff>
                    <maskedEditBox />
                    <maskedEditBox2 />
                    <showData />
                    <controls />
                </control>
                <control name="txtYrsExp" type="WisTextBox">
                    <LostFocusCode />
                    <GotFocusCode />
                    <ClickCode />
                    <TextChangedCode />
                    <enableControls />
                    <sumTotalControls />
                    <acceptsTab>False</acceptsTab>
                    <acceptsReturn>False</acceptsReturn>
                    <backColor>
                        <r>255</r>
                        <g>255</g>
                        <b>255</b>
                    </backColor>
                    <borderStyle>1</borderStyle>
                    <boundScreen />
                    <characterCasing>0</characterCasing>
                    <columnName>YRSEXP</columnName>
                    <description>How many years experience do you have?</description>
                    <decimalPlaces>0</decimalPlaces>
                    <useDecimalPlaces>False</useDecimalPlaces>
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>21</height>
                    <left>396</left>
                    <font>
                        <bold>False</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <linkedData />
                    <maxLength>2</maxLength>
                    <multiLine>False</multiLine>
                    <numeric>True</numeric>
                    <autoIncrement>False</autoIncrement>
                    <maxAutoValue>0</maxAutoValue>
                    <properCase>False</properCase>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>35</tabIndex>
                    <text />
                    <textAlign>0</textAlign>
                    <top>42</top>
                    <width>42</width>
                    <showData />
                    <objectID>0</objectID>
                    <longPropertyID>0</longPropertyID>
                    <defaultValue />
                    <showHelpText>False</showHelpText>
                    <helpText />
                    <required>True</required>
                    <displayOnWebpage>True</displayOnWebpage>
                    <alwaysVisible>False</alwaysVisible>
                    <startYear />
                    <endYear />
                    <controls />
                </control>
                <control name="lblYrsExpQuestion" type="WisLabel">
                    <sumTotalControls />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <boundTransform />
                    <description>txtYrsExp</description>
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>23</height>
                    <left>9</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>0</tabIndex>
                    <text>How many years experience do you have?</text>
                    <textAlign>1</textAlign>
                    <top>44</top>
                    <width>246</width>
                    <isDateDiff>0</isDateDiff>
                    <maskedEditBox />
                    <maskedEditBox2 />
                    <showData />
                    <controls />
                </control>
            </controls>
        </control>
        <control name="grpSafety" type="GroupBox">
            <backColor>
                <r>212</r>
                <g>208</g>
                <b>200</b>
            </backColor>
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>207</height>
            <left>445</left>
            <font>
                <bold>True</bold>
                <fontName>Tahoma</fontName>
                <italic>False</italic>
                <size>8.25</size>
                <strikeout>False</strikeout>
                <underline>False</underline>
            </font>
            <rightToLeft>0</rightToLeft>
            <tabIndex>49</tabIndex>
            <text>Safety</text>
            <top>536</top>
            <width>444</width>
            <controls>
                <control name="optWrittenRA" type="tgsYesNo">
                    <LostFocusCode />
                    <GotFocusCode />
                    <ClickCode />
                    <enableControls />
                    <displayPages />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <columnName>WRITTENRA</columnName>
                    <description>responsible for written risk assessments?</description>
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>27</height>
                    <left>345</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <linkedData />
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>53</tabIndex>
                    <text />
                    <top>160</top>
                    <width>93</width>
                    <showData />
                    <objectID>0</objectID>
                    <longPropertyID>0</longPropertyID>
                    <defaultValue />
                    <showHelpText>True</showHelpText>
                    <helpText>If your business completes Risk Assessments &amp;&amp; Method Statements where appropriate, please select 'yes'. Otherwise tick 'no'.</helpText>
                    <required>True</required>
                    <displayOnWebpage>True</displayOnWebpage>
                    <alwaysVisible>False</alwaysVisible>
                    <controls />
                </control>
                <control name="WisLabel27" type="WisLabel">
                    <sumTotalControls />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <boundTransform />
                    <description>optWrittenRA</description>
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>36</height>
                    <left>6</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>0</tabIndex>
                    <text>Do you complete Risk Assessments &amp;&amp; Method Statements where appropriate?</text>
                    <textAlign>1</textAlign>
                    <top>160</top>
                    <width>318</width>
                    <isDateDiff>0</isDateDiff>
                    <maskedEditBox />
                    <maskedEditBox2 />
                    <showData />
                    <controls />
                </control>
                <control name="optHealthSafety" type="tgsYesNo">
                    <LostFocusCode />
                    <GotFocusCode />
                    <ClickCode />
                    <enableControls />
                    <displayPages />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <columnName>HEALTHSAFETY</columnName>
                    <description>anyone who is responsible for Health and Safety?</description>
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>27</height>
                    <left>344</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <linkedData />
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>52</tabIndex>
                    <text />
                    <top>93</top>
                    <width>93</width>
                    <showData />
                    <objectID>0</objectID>
                    <longPropertyID>0</longPropertyID>
                    <defaultValue />
                    <showHelpText>True</showHelpText>
                    <helpText>If your business complies with HSE rules and regulations, please select 'yes'. Otherwise tick 'no'.</helpText>
                    <required>True</required>
                    <displayOnWebpage>True</displayOnWebpage>
                    <alwaysVisible>False</alwaysVisible>
                    <controls />
                </control>
                <control name="WisLabel26" type="WisLabel">
                    <sumTotalControls />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <boundTransform />
                    <description>optHealthSafety</description>
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>67</height>
                    <left>9</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>0</tabIndex>
                    <text>Does your business comply with HSE rules and regulations?</text>
                    <textAlign>16</textAlign>
                    <top>84</top>
                    <width>315</width>
                    <isDateDiff>0</isDateDiff>
                    <maskedEditBox />
                    <maskedEditBox2 />
                    <showData />
                    <controls />
                </control>
                <control name="cboWhichAssoci" type="WisComboBox">
                    <LostFocusCode />
                    <GotFocusCode />
                    <ClickCode />
                    <TextChangedCode />
                    <SelectedIndexChangedCode />
                    <enableControls />
                    <backColor>
                        <r>255</r>
                        <g>255</g>
                        <b>255</b>
                    </backColor>
                    <boundScreen />
                    <columnName>MH_ASSOC_FED_ID</columnName>
                    <description>Please select which one</description>
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>21</height>
                    <left>345</left>
                    <font>
                        <bold>False</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <linkedData />
                    <listTable>LIST_MH_ASSOC_FED</listTable>
                    <maxLength>0</maxLength>
                    <numeric>False</numeric>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>51</tabIndex>
                    <userFilled>False</userFilled>
                    <filteredDropdown />
                    <text />
                    <top>53</top>
                    <width>93</width>
                    <showData />
                    <objectID>0</objectID>
                    <longPropertyID>0</longPropertyID>
                    <defaultValue />
                    <showHelpText>False</showHelpText>
                    <helpText />
                    <required>True</required>
                    <displayOnWebpage>True</displayOnWebpage>
                    <alwaysVisible>False</alwaysVisible>
                    <controls />
                </control>
                <control name="WisLabel25" type="WisLabel">
                    <sumTotalControls />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <boundTransform />
                    <description>cboWhichAssoci</description>
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>23</height>
                    <left>9</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>0</tabIndex>
                    <text>Please select which one</text>
                    <textAlign>1</textAlign>
                    <top>56</top>
                    <width>156</width>
                    <isDateDiff>0</isDateDiff>
                    <maskedEditBox />
                    <maskedEditBox2 />
                    <showData />
                    <controls />
                </control>
                <control name="optAssociMem" type="tgsYesNo">
                    <LostFocusCode />
                    <GotFocusCode />
                    <ClickCode />
                    <enableControls>
                        <enableControl>
                            <boundScreen>MLIAB\frmCInfo.tst</boundScreen>
                            <control>cboWhichAssoci</control>
                            <enable>True</enable>
                        </enableControl>
                        <enableControl>
                            <boundScreen>MLIAB\frmCInfo.tst</boundScreen>
                            <control>WisLabel25</control>
                            <enable>True</enable>
                        </enableControl>
                    </enableControls>
                    <displayPages />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <columnName>ASSOCIMEM</columnName>
                    <description>Are you a member of any association or federation?</description>
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>27</height>
                    <left>345</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <linkedData />
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>50</tabIndex>
                    <text />
                    <top>20</top>
                    <width>93</width>
                    <showData />
                    <objectID>0</objectID>
                    <longPropertyID>0</longPropertyID>
                    <defaultValue />
                    <showHelpText>True</showHelpText>
                    <helpText>If you are a member of an association or federation, please select 'yes' and choose from the drop down menu. If you cannot see your association/federation, please select 'other'.</helpText>
                    <required>True</required>
                    <displayOnWebpage>True</displayOnWebpage>
                    <alwaysVisible>False</alwaysVisible>
                    <controls />
                </control>
                <control name="WisLabel24" type="WisLabel">
                    <sumTotalControls />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <boundTransform />
                    <description>optAssociMem</description>
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>23</height>
                    <left>9</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>0</tabIndex>
                    <text>Are you a member of any association or federation?</text>
                    <textAlign>16</textAlign>
                    <top>20</top>
                    <width>315</width>
                    <isDateDiff>0</isDateDiff>
                    <maskedEditBox />
                    <maskedEditBox2 />
                    <showData />
                    <controls />
                </control>
            </controls>
        </control>
        <control name="grpConditions" type="GroupBox">
            <backColor>
                <r>212</r>
                <g>208</g>
                <b>200</b>
            </backColor>
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>141</height>
            <left>445</left>
            <font>
                <bold>True</bold>
                <fontName>Tahoma</fontName>
                <italic>False</italic>
                <size>8.25</size>
                <strikeout>False</strikeout>
                <underline>False</underline>
            </font>
            <rightToLeft>0</rightToLeft>
            <tabIndex>44</tabIndex>
            <text>Conditions</text>
            <top>389</top>
            <width>444</width>
            <controls>
                <control name="cboMaxHeight" type="WisComboBox">
                    <LostFocusCode />
                    <GotFocusCode />
                    <ClickCode />
                    <TextChangedCode />
                    <SelectedIndexChangedCode />
                    <enableControls />
                    <backColor>
                        <r>255</r>
                        <g>255</g>
                        <b>255</b>
                    </backColor>
                    <boundScreen />
                    <columnName>MH_MAXHEIGHT_ID</columnName>
                    <description>What is the maximum height you work at</description>
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>21</height>
                    <left>345</left>
                    <font>
                        <bold>False</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <linkedData />
                    <listTable>LIST_MH_MAXHEIGHT</listTable>
                    <maxLength>0</maxLength>
                    <numeric>True</numeric>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>48</tabIndex>
                    <userFilled>False</userFilled>
                    <filteredDropdown />
                    <text />
                    <top>111</top>
                    <width>93</width>
                    <showData />
                    <objectID>0</objectID>
                    <longPropertyID>0</longPropertyID>
                    <defaultValue />
                    <showHelpText>True</showHelpText>
                    <helpText>Please specify the maximum height that you work at when carrying out your job e.g. if you are a builder you may frequently work at a height of 15m. If this does not apply to you, please enter '0'.</helpText>
                    <required>True</required>
                    <displayOnWebpage>True</displayOnWebpage>
                    <alwaysVisible>False</alwaysVisible>
                    <controls />
                </control>
                <control name="WisLabel23" type="WisLabel">
                    <sumTotalControls />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <boundTransform />
                    <description>cboMaxHeight</description>
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>23</height>
                    <left>9</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>0</tabIndex>
                    <text>What is the maximum height you work at (in meters)?</text>
                    <textAlign>1</textAlign>
                    <top>114</top>
                    <width>328</width>
                    <isDateDiff>0</isDateDiff>
                    <maskedEditBox />
                    <maskedEditBox2 />
                    <showData />
                    <controls />
                </control>
                <control name="txtHeatPercent" type="WisTextBox">
                    <LostFocusCode />
                    <GotFocusCode />
                    <ClickCode />
                    <TextChangedCode />
                    <enableControls />
                    <sumTotalControls />
                    <acceptsTab>False</acceptsTab>
                    <acceptsReturn>False</acceptsReturn>
                    <backColor>
                        <r>255</r>
                        <g>255</g>
                        <b>255</b>
                    </backColor>
                    <borderStyle>1</borderStyle>
                    <boundScreen />
                    <characterCasing>0</characterCasing>
                    <columnName>HEATPERCENT</columnName>
                    <description>What percentage?</description>
                    <decimalPlaces>0</decimalPlaces>
                    <useDecimalPlaces>False</useDecimalPlaces>
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>21</height>
                    <left>345</left>
                    <font>
                        <bold>False</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <linkedData />
                    <maxLength>3</maxLength>
                    <multiLine>False</multiLine>
                    <numeric>True</numeric>
                    <autoIncrement>False</autoIncrement>
                    <maxAutoValue>0</maxAutoValue>
                    <properCase>False</properCase>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>47</tabIndex>
                    <text />
                    <textAlign>0</textAlign>
                    <top>84</top>
                    <width>93</width>
                    <showData />
                    <objectID>0</objectID>
                    <longPropertyID>0</longPropertyID>
                    <defaultValue />
                    <showHelpText>False</showHelpText>
                    <helpText />
                    <required>True</required>
                    <displayOnWebpage>True</displayOnWebpage>
                    <alwaysVisible>False</alwaysVisible>
                    <startYear />
                    <endYear />
                    <controls />
                </control>
                <control name="WisLabel22" type="WisLabel">
                    <sumTotalControls />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <boundTransform />
                    <description>txtHeatPercent</description>
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>23</height>
                    <left>9</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>0</tabIndex>
                    <text>What percentage?</text>
                    <textAlign>1</textAlign>
                    <top>86</top>
                    <width>141</width>
                    <isDateDiff>0</isDateDiff>
                    <maskedEditBox />
                    <maskedEditBox2 />
                    <showData />
                    <controls />
                </control>
                <control name="optHeat" type="tgsYesNo">
                    <LostFocusCode />
                    <GotFocusCode />
                    <ClickCode />
                    <enableControls>
                        <enableControl>
                            <boundScreen>MLIAB\frmCInfo.tst</boundScreen>
                            <control>txtHeatPercent</control>
                            <enable>True</enable>
                        </enableControl>
                        <enableControl>
                            <boundScreen>MLIAB\frmCInfo.tst</boundScreen>
                            <control>WisLabel22</control>
                            <enable>True</enable>
                        </enableControl>
                    </enableControls>
                    <displayPages />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <columnName>HEAT</columnName>
                    <description>Do you use heat?</description>
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>27</height>
                    <left>345</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <linkedData />
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>46</tabIndex>
                    <text />
                    <top>51</top>
                    <width>93</width>
                    <showData />
                    <objectID>0</objectID>
                    <longPropertyID>0</longPropertyID>
                    <defaultValue />
                    <showHelpText>True</showHelpText>
                    <helpText>If you use blow lamps, blow torches, hot air guns, welding/oxy-acetylene/flame cutting equipment or any other equipment involving the application of heat, you must answer 'yes' to this question.</helpText>
                    <required>True</required>
                    <displayOnWebpage>True</displayOnWebpage>
                    <alwaysVisible>False</alwaysVisible>
                    <controls />
                </control>
                <control name="WisLabel21" type="WisLabel">
                    <sumTotalControls />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <boundTransform />
                    <description>optHeat</description>
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>23</height>
                    <left>9</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>0</tabIndex>
                    <text>Do you use heat?</text>
                    <textAlign>16</textAlign>
                    <top>51</top>
                    <width>141</width>
                    <isDateDiff>0</isDateDiff>
                    <maskedEditBox />
                    <maskedEditBox2 />
                    <showData />
                    <controls />
                </control>
                <control name="optWorkSoley" type="tgsYesNo">
                    <LostFocusCode />
                    <GotFocusCode />
                    <ClickCode />
                    <enableControls />
                    <displayPages />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <columnName>WORKSOLEY</columnName>
                    <description>Do you work solely on Private Dwelling Houses</description>
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>27</height>
                    <left>345</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <linkedData />
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>45</tabIndex>
                    <text />
                    <top>18</top>
                    <width>93</width>
                    <showData />
                    <objectID>0</objectID>
                    <longPropertyID>0</longPropertyID>
                    <defaultValue />
                    <showHelpText>True</showHelpText>
                    <helpText>If you do other types of work, outside of work on Private Dwelling Houses, Offices and Shops, please select 'no'.</helpText>
                    <required>True</required>
                    <displayOnWebpage>True</displayOnWebpage>
                    <alwaysVisible>False</alwaysVisible>
                    <controls />
                </control>
                <control name="WisLabel20" type="WisLabel">
                    <sumTotalControls />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <boundTransform />
                    <description>optWorkSoley</description>
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>23</height>
                    <left>9</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>0</tabIndex>
                    <text>Do you work solely on Private Dwelling Houses, Offices, Shops only?</text>
                    <textAlign>16</textAlign>
                    <top>22</top>
                    <width>286</width>
                    <isDateDiff>0</isDateDiff>
                    <maskedEditBox />
                    <maskedEditBox2 />
                    <showData />
                    <controls />
                </control>
            </controls>
        </control>
        <control name="grpWagerolls" type="GroupBox">
            <backColor>
                <r>212</r>
                <g>208</g>
                <b>200</b>
            </backColor>
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>152</height>
            <left>445</left>
            <font>
                <bold>True</bold>
                <fontName>Tahoma</fontName>
                <italic>False</italic>
                <size>8.25</size>
                <strikeout>False</strikeout>
                <underline>False</underline>
            </font>
            <rightToLeft>0</rightToLeft>
            <tabIndex>38</tabIndex>
            <text>Wagerolls</text>
            <top>229</top>
            <width>444</width>
            <controls>
                <control name="cfdPsDrawings" type="tgsCurrencyField">
                    <LostFocusCode />
                    <GotFocusCode />
                    <ClickCode />
                    <TextChangedCode />
                    <ValueChangedCode />
                    <enableControls />
                    <sumTotalControls />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <columnName>PSDRAWINGS</columnName>
                    <codeEnabled>False</codeEnabled>
                    <description>What are the principals drawings?</description>
                    <decimalPlaces>0</decimalPlaces>
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <editable>True</editable>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>21</height>
                    <left>293</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <rightToLeft>0</rightToLeft>
                    <symbolEnabled>True</symbolEnabled>
                    <tabIndex>43</tabIndex>
                    <text />
                    <top>121</top>
                    <width>145</width>
                    <sumInsured>False</sumInsured>
                    <showData />
                    <objectID>0</objectID>
                    <longPropertyID>0</longPropertyID>
                    <defaultValue />
                    <showHelpText>False</showHelpText>
                    <helpText />
                    <required>True</required>
                    <displayOnWebpage>True</displayOnWebpage>
                    <alwaysVisible>False</alwaysVisible>
                    <controls />
                </control>
                <control name="WisLabel19" type="WisLabel">
                    <sumTotalControls />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <boundTransform />
                    <description>cfdPsDrawings</description>
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>21</height>
                    <left>9</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>0</tabIndex>
                    <text>What are the principals drawings?</text>
                    <textAlign>16</textAlign>
                    <top>121</top>
                    <width>203</width>
                    <isDateDiff>0</isDateDiff>
                    <maskedEditBox />
                    <maskedEditBox2 />
                    <showData />
                    <controls />
                </control>
                <control name="cfdSupervisorWR" type="tgsCurrencyField">
                    <LostFocusCode />
                    <GotFocusCode />
                    <ClickCode />
                    <TextChangedCode />
                    <ValueChangedCode />
                    <enableControls />
                    <sumTotalControls />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <columnName>SUPERVISORWR</columnName>
                    <codeEnabled>False</codeEnabled>
                    <description>Total Supervisor / Yardmen wages</description>
                    <decimalPlaces>0</decimalPlaces>
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <editable>True</editable>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>21</height>
                    <left>293</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <rightToLeft>0</rightToLeft>
                    <symbolEnabled>True</symbolEnabled>
                    <tabIndex>42</tabIndex>
                    <text />
                    <top>94</top>
                    <width>145</width>
                    <sumInsured>False</sumInsured>
                    <showData />
                    <objectID>0</objectID>
                    <longPropertyID>0</longPropertyID>
                    <defaultValue />
                    <showHelpText>False</showHelpText>
                    <helpText />
                    <required>True</required>
                    <displayOnWebpage>True</displayOnWebpage>
                    <alwaysVisible>False</alwaysVisible>
                    <controls />
                </control>
                <control name="WisLabel18" type="WisLabel">
                    <sumTotalControls />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <boundTransform />
                    <description>cfdSupervisorWR</description>
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>21</height>
                    <left>9</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>0</tabIndex>
                    <text>Total Supervisor / Yardmen wages</text>
                    <textAlign>16</textAlign>
                    <top>94</top>
                    <width>203</width>
                    <isDateDiff>0</isDateDiff>
                    <maskedEditBox />
                    <maskedEditBox2 />
                    <showData />
                    <controls />
                </control>
                <control name="cfdLabourWR" type="tgsCurrencyField">
                    <LostFocusCode />
                    <GotFocusCode />
                    <ClickCode />
                    <TextChangedCode />
                    <ValueChangedCode />
                    <enableControls />
                    <sumTotalControls />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <columnName>LABOURWR</columnName>
                    <codeEnabled>False</codeEnabled>
                    <description>Labour Only Wageroll</description>
                    <decimalPlaces>0</decimalPlaces>
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <editable>True</editable>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>21</height>
                    <left>293</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <rightToLeft>0</rightToLeft>
                    <symbolEnabled>True</symbolEnabled>
                    <tabIndex>41</tabIndex>
                    <text />
                    <top>67</top>
                    <width>145</width>
                    <sumInsured>False</sumInsured>
                    <showData />
                    <objectID>0</objectID>
                    <longPropertyID>0</longPropertyID>
                    <defaultValue />
                    <showHelpText>False</showHelpText>
                    <helpText />
                    <required>True</required>
                    <displayOnWebpage>True</displayOnWebpage>
                    <alwaysVisible>False</alwaysVisible>
                    <controls />
                </control>
                <control name="WisLabel17" type="WisLabel">
                    <sumTotalControls />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <boundTransform />
                    <description>cfdLabourWR</description>
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>21</height>
                    <left>9</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>0</tabIndex>
                    <text>Labour Only Wageroll</text>
                    <textAlign>16</textAlign>
                    <top>67</top>
                    <width>141</width>
                    <isDateDiff>0</isDateDiff>
                    <maskedEditBox />
                    <maskedEditBox2 />
                    <showData />
                    <controls />
                </control>
                <control name="cfdClericalPAYE" type="tgsCurrencyField">
                    <LostFocusCode />
                    <GotFocusCode />
                    <ClickCode />
                    <TextChangedCode />
                    <ValueChangedCode />
                    <enableControls />
                    <sumTotalControls />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <columnName>CLERICALPAYE</columnName>
                    <codeEnabled>False</codeEnabled>
                    <description>PAYE Wageroll for Clerical Employees</description>
                    <decimalPlaces>0</decimalPlaces>
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <editable>True</editable>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>21</height>
                    <left>293</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <rightToLeft>0</rightToLeft>
                    <symbolEnabled>True</symbolEnabled>
                    <tabIndex>40</tabIndex>
                    <text />
                    <top>40</top>
                    <width>145</width>
                    <sumInsured>False</sumInsured>
                    <showData />
                    <objectID>0</objectID>
                    <longPropertyID>0</longPropertyID>
                    <defaultValue />
                    <showHelpText>False</showHelpText>
                    <helpText />
                    <required>True</required>
                    <displayOnWebpage>True</displayOnWebpage>
                    <alwaysVisible>False</alwaysVisible>
                    <controls />
                </control>
                <control name="WisLabel16" type="WisLabel">
                    <sumTotalControls />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <boundTransform />
                    <description>cfdClericalPAYE</description>
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>21</height>
                    <left>9</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>0</tabIndex>
                    <text>PAYE Wageroll for Clerical Employees</text>
                    <textAlign>16</textAlign>
                    <top>40</top>
                    <width>227</width>
                    <isDateDiff>0</isDateDiff>
                    <maskedEditBox />
                    <maskedEditBox2 />
                    <showData />
                    <controls />
                </control>
                <control name="cfdManualPAYE" type="tgsCurrencyField">
                    <LostFocusCode />
                    <GotFocusCode />
                    <ClickCode />
                    <TextChangedCode />
                    <ValueChangedCode />
                    <enableControls />
                    <sumTotalControls />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <columnName>MANUALPAYE</columnName>
                    <codeEnabled>False</codeEnabled>
                    <description>Direct Manual Wageroll (PAYE)</description>
                    <decimalPlaces>0</decimalPlaces>
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <editable>True</editable>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>21</height>
                    <left>293</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <rightToLeft>0</rightToLeft>
                    <symbolEnabled>True</symbolEnabled>
                    <tabIndex>39</tabIndex>
                    <text />
                    <top>13</top>
                    <width>145</width>
                    <sumInsured>False</sumInsured>
                    <showData />
                    <objectID>0</objectID>
                    <longPropertyID>0</longPropertyID>
                    <defaultValue />
                    <showHelpText>False</showHelpText>
                    <helpText />
                    <required>True</required>
                    <displayOnWebpage>True</displayOnWebpage>
                    <alwaysVisible>False</alwaysVisible>
                    <controls />
                </control>
                <control name="WisLabel15" type="WisLabel">
                    <sumTotalControls />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <boundTransform />
                    <description>cfdManualPAYE</description>
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>21</height>
                    <left>9</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>0</tabIndex>
                    <text>Direct Manual Wageroll (PAYE)</text>
                    <textAlign>16</textAlign>
                    <top>13</top>
                    <width>194</width>
                    <isDateDiff>0</isDateDiff>
                    <maskedEditBox />
                    <maskedEditBox2 />
                    <showData />
                    <controls />
                </control>
            </controls>
        </control>
        <control name="grpClientInfo" type="GroupBox">
            <backColor>
                <r>212</r>
                <g>208</g>
                <b>200</b>
            </backColor>
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>626</height>
            <left>10</left>
            <font>
                <bold>True</bold>
                <fontName>Tahoma</fontName>
                <italic>False</italic>
                <size>8.25</size>
                <strikeout>False</strikeout>
                <underline>False</underline>
            </font>
            <rightToLeft>0</rightToLeft>
            <tabIndex>6</tabIndex>
            <text>Client Information</text>
            <top>165</top>
            <width>429</width>
            <controls>
                <control name="grpERN" type="GroupBox">
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>76</height>
                    <left>6</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>26</tabIndex>
                    <text />
                    <top>542</top>
                    <width>417</width>
                    <controls>
                        <control name="WisLabel31" type="WisLabel">
                            <sumTotalControls />
                            <backColor>
                                <r>212</r>
                                <g>208</g>
                                <b>200</b>
                            </backColor>
                            <borderStyle>0</borderStyle>
                            <boundScreen />
                            <boundTransform />
                            <description>txtERNRef</description>
                            <maximumTotal>0</maximumTotal>
                            <minimumTotal />
                            <enabled>True</enabled>
                            <foreColor>
                                <r>0</r>
                                <g>0</g>
                                <b>0</b>
                            </foreColor>
                            <height>51</height>
                            <left>6</left>
                            <font>
                                <bold>True</bold>
                                <fontName>Tahoma</fontName>
                                <italic>False</italic>
                                <size>8.25</size>
                                <strikeout>False</strikeout>
                                <underline>False</underline>
                            </font>
                            <rightToLeft>0</rightToLeft>
                            <tabIndex>0</tabIndex>
                            <text>What is your Employers Reference Number (ERN), also known as PAYE reference? If your company does not have an ERN please tick Exempt.</text>
                            <textAlign>1</textAlign>
                            <top>17</top>
                            <width>298</width>
                            <isDateDiff>0</isDateDiff>
                            <maskedEditBox />
                            <maskedEditBox2 />
                            <showData />
                            <controls />
                        </control>
                        <control name="chkERNExempt" type="WisCheckBox">
                            <LostFocusCode />
                            <GotFocusCode />
                            <ClickCode />
                            <enableControls>
                                <enableControl>
                                    <boundScreen>MLIAB\frmCInfo.tst</boundScreen>
                                    <control>txtERNRef</control>
                                    <enable>False</enable>
                                </enableControl>
                            </enableControls>
                            <displayPages />
                            <appearance>0</appearance>
                            <backColor>
                                <r>212</r>
                                <g>208</g>
                                <b>200</b>
                            </backColor>
                            <boundScreen />
                            <columnName>ERNEXEMPT</columnName>
                            <description>ERNExempt</description>
                            <enabled>True</enabled>
                            <foreColor>
                                <r>0</r>
                                <g>0</g>
                                <b>0</b>
                            </foreColor>
                            <height>21</height>
                            <left>307</left>
                            <font>
                                <bold>True</bold>
                                <fontName>Tahoma</fontName>
                                <italic>False</italic>
                                <size>8.25</size>
                                <strikeout>False</strikeout>
                                <underline>False</underline>
                            </font>
                            <linkedData />
                            <rightToLeft>0</rightToLeft>
                            <tabIndex>28</tabIndex>
                            <checkAlign>64</checkAlign>
                            <text>Exempt</text>
                            <textAlign>64</textAlign>
                            <top>42</top>
                            <width>104</width>
                            <showData />
                            <objectID>0</objectID>
                            <longPropertyID>0</longPropertyID>
                            <defaultValue />
                            <showHelpText>False</showHelpText>
                            <helpText />
                            <required>False</required>
                            <displayOnWebpage>True</displayOnWebpage>
                            <alwaysVisible>False</alwaysVisible>
                            <displayAsYesNo>False</displayAsYesNo>
                            <controls />
                        </control>
                        <control name="txtERNRef" type="WisTextBox">
                            <LostFocusCode />
                            <GotFocusCode />
                            <ClickCode />
                            <TextChangedCode />
                            <enableControls />
                            <sumTotalControls />
                            <acceptsTab>False</acceptsTab>
                            <acceptsReturn>False</acceptsReturn>
                            <backColor>
                                <r>255</r>
                                <g>255</g>
                                <b>255</b>
                            </backColor>
                            <borderStyle>1</borderStyle>
                            <boundScreen />
                            <characterCasing>0</characterCasing>
                            <columnName>ERNREF</columnName>
                            <description>What is your Employers Reference Number?</description>
                            <decimalPlaces>0</decimalPlaces>
                            <useDecimalPlaces>False</useDecimalPlaces>
                            <maximumTotal />
                            <minimumTotal />
                            <enabled>True</enabled>
                            <foreColor>
                                <r>0</r>
                                <g>0</g>
                                <b>0</b>
                            </foreColor>
                            <height>21</height>
                            <left>310</left>
                            <font>
                                <bold>False</bold>
                                <fontName>Tahoma</fontName>
                                <italic>False</italic>
                                <size>8.25</size>
                                <strikeout>False</strikeout>
                                <underline>False</underline>
                            </font>
                            <linkedData />
                            <maxLength>20</maxLength>
                            <multiLine>False</multiLine>
                            <numeric>False</numeric>
                            <autoIncrement>False</autoIncrement>
                            <maxAutoValue>0</maxAutoValue>
                            <properCase>False</properCase>
                            <rightToLeft>0</rightToLeft>
                            <tabIndex>27</tabIndex>
                            <text />
                            <textAlign>0</textAlign>
                            <top>15</top>
                            <width>101</width>
                            <showData />
                            <objectID>0</objectID>
                            <longPropertyID>0</longPropertyID>
                            <defaultValue />
                            <showHelpText>True</showHelpText>
                            <helpText>What is your Employers Reference Number (ERN), also known as PAYE reference? If your company does not have an ERN please tick Exempt.</helpText>
                            <required>False</required>
                            <displayOnWebpage>True</displayOnWebpage>
                            <alwaysVisible>False</alwaysVisible>
                            <startYear />
                            <endYear />
                            <controls />
                        </control>
                    </controls>
                </control>
                <control name="grpsubsid" type="GroupBox">
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>186</height>
                    <left>6</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>9</tabIndex>
                    <text>Subsidiaries</text>
                    <top>71</top>
                    <width>417</width>
                    <controls>
                        <control name="WisLabel32" type="WisLabel">
                            <sumTotalControls />
                            <backColor>
                                <r>212</r>
                                <g>208</g>
                                <b>200</b>
                            </backColor>
                            <borderStyle>0</borderStyle>
                            <boundScreen />
                            <boundTransform />
                            <description>optincludeYN</description>
                            <maximumTotal>0</maximumTotal>
                            <minimumTotal />
                            <enabled>True</enabled>
                            <foreColor>
                                <r>0</r>
                                <g>0</g>
                                <b>0</b>
                            </foreColor>
                            <height>23</height>
                            <left>6</left>
                            <font>
                                <bold>True</bold>
                                <fontName>Tahoma</fontName>
                                <italic>False</italic>
                                <size>8.25</size>
                                <strikeout>False</strikeout>
                                <underline>False</underline>
                            </font>
                            <rightToLeft>0</rightToLeft>
                            <tabIndex>0</tabIndex>
                            <text>Do you want to include these subsidiary companies on this policy?</text>
                            <textAlign>16</textAlign>
                            <top>50</top>
                            <width>287</width>
                            <isDateDiff>0</isDateDiff>
                            <maskedEditBox />
                            <maskedEditBox2 />
                            <showData />
                            <controls />
                        </control>
                        <control name="optincludeYN" type="tgsYesNo">
                            <LostFocusCode />
                            <GotFocusCode />
                            <ClickCode />
                            <enableControls />
                            <displayPages />
                            <backColor>
                                <r>212</r>
                                <g>208</g>
                                <b>200</b>
                            </backColor>
                            <borderStyle>0</borderStyle>
                            <boundScreen />
                            <columnName>INCLUDEYN</columnName>
                            <description>Do you want to include these subs</description>
                            <enabled>True</enabled>
                            <foreColor>
                                <r>0</r>
                                <g>0</g>
                                <b>0</b>
                            </foreColor>
                            <height>27</height>
                            <left>318</left>
                            <font>
                                <bold>True</bold>
                                <fontName>Tahoma</fontName>
                                <italic>False</italic>
                                <size>8.25</size>
                                <strikeout>False</strikeout>
                                <underline>False</underline>
                            </font>
                            <linkedData />
                            <rightToLeft>0</rightToLeft>
                            <tabIndex>11</tabIndex>
                            <text />
                            <top>50</top>
                            <width>93</width>
                            <showData />
                            <objectID>0</objectID>
                            <longPropertyID>0</longPropertyID>
                            <defaultValue />
                            <showHelpText>False</showHelpText>
                            <helpText />
                            <required>True</required>
                            <displayOnWebpage>False</displayOnWebpage>
                            <alwaysVisible>True</alwaysVisible>
                            <controls />
                        </control>
                        <control name="cmdSubsidRemove" type="WisButton">
                            <LostFocusCode />
                            <GotFocusCode />
                            <ClickCode />
                            <backColor>
                                <r>212</r>
                                <g>208</g>
                                <b>200</b>
                            </backColor>
                            <description>Remove Sub</description>
                            <foreColor>
                                <r>0</r>
                                <g>0</g>
                                <b>0</b>
                            </foreColor>
                            <height>23</height>
                            <left>336</left>
                            <listView>lvwSubSid</listView>
                            <top>147</top>
                            <tabIndex>15</tabIndex>
                            <type>5</type>
                            <text>    &amp;Remove</text>
                            <width>75</width>
                        </control>
                        <control name="cmdSubsidEdit" type="WisButton">
                            <LostFocusCode />
                            <GotFocusCode />
                            <ClickCode />
                            <backColor>
                                <r>212</r>
                                <g>208</g>
                                <b>200</b>
                            </backColor>
                            <description>Edit Sub</description>
                            <foreColor>
                                <r>0</r>
                                <g>0</g>
                                <b>0</b>
                            </foreColor>
                            <height>23</height>
                            <left>255</left>
                            <listView>lvwSubSid</listView>
                            <top>147</top>
                            <tabIndex>14</tabIndex>
                            <type>4</type>
                            <text>  &amp;Edit</text>
                            <width>75</width>
                        </control>
                        <control name="cmdSubsidAdd" type="WisButton">
                            <LostFocusCode />
                            <GotFocusCode />
                            <ClickCode />
                            <backColor>
                                <r>212</r>
                                <g>208</g>
                                <b>200</b>
                            </backColor>
                            <description>Add Sub</description>
                            <foreColor>
                                <r>0</r>
                                <g>0</g>
                                <b>0</b>
                            </foreColor>
                            <height>23</height>
                            <left>174</left>
                            <listView>lvwSubSid</listView>
                            <top>147</top>
                            <tabIndex>13</tabIndex>
                            <type>3</type>
                            <text>  &amp;Add</text>
                            <width>75</width>
                        </control>
                        <control name="lvwSubSid" type="WisListView">
                            <columns>
                                <column>
                                    <text>Company</text>
                                    <Width>240</Width>
                                    <bindControl>txtSubsidName</bindControl>
                                </column>
                                <column>
                                    <text>ERN</text>
                                    <Width>68</Width>
                                    <bindControl>txtSubsidERN</bindControl>
                                </column>
                                <column>
                                    <text>Insurer</text>
                                    <Width>95</Width>
                                    <bindControl>cboSubsidInsurer</bindControl>
                                </column>
                            </columns>
                            <backColor>
                                <r>255</r>
                                <g>255</g>
                                <b>255</b>
                            </backColor>
                            <borderStyle>1</borderStyle>
                            <boundScreen>MLIAB\frmSubsid.tst</boundScreen>
                            <description>Sub List</description>
                            <enabled>True</enabled>
                            <foreColor>
                                <r>0</r>
                                <g>0</g>
                                <b>0</b>
                            </foreColor>
                            <height>51</height>
                            <left>6</left>
                            <font>
                                <bold>False</bold>
                                <fontName>Tahoma</fontName>
                                <italic>False</italic>
                                <size>8.25</size>
                                <strikeout>False</strikeout>
                                <underline>False</underline>
                            </font>
                            <rightToLeft>0</rightToLeft>
                            <tabIndex>12</tabIndex>
                            <text />
                            <top>85</top>
                            <width>405</width>
                            <controls />
                        </control>
                        <control name="optSubsidYN" type="tgsYesNo">
                            <LostFocusCode />
                            <GotFocusCode />
                            <ClickCode />
                            <enableControls />
                            <displayPages />
                            <backColor>
                                <r>212</r>
                                <g>208</g>
                                <b>200</b>
                            </backColor>
                            <borderStyle>0</borderStyle>
                            <boundScreen />
                            <columnName>SUBSIDYN</columnName>
                            <description>Do you have any subsidiary</description>
                            <enabled>True</enabled>
                            <foreColor>
                                <r>0</r>
                                <g>0</g>
                                <b>0</b>
                            </foreColor>
                            <height>27</height>
                            <left>318</left>
                            <font>
                                <bold>True</bold>
                                <fontName>Tahoma</fontName>
                                <italic>False</italic>
                                <size>8.25</size>
                                <strikeout>False</strikeout>
                                <underline>False</underline>
                            </font>
                            <linkedData />
                            <rightToLeft>0</rightToLeft>
                            <tabIndex>10</tabIndex>
                            <text />
                            <top>17</top>
                            <width>93</width>
                            <showData />
                            <objectID>0</objectID>
                            <longPropertyID>0</longPropertyID>
                            <defaultValue />
                            <showHelpText>False</showHelpText>
                            <helpText />
                            <required>True</required>
                            <displayOnWebpage>False</displayOnWebpage>
                            <alwaysVisible>True</alwaysVisible>
                            <controls />
                        </control>
                        <control name="WisLabel12" type="WisLabel">
                            <sumTotalControls />
                            <backColor>
                                <r>212</r>
                                <g>208</g>
                                <b>200</b>
                            </backColor>
                            <borderStyle>0</borderStyle>
                            <boundScreen />
                            <boundTransform />
                            <description>optSubsidYN</description>
                            <maximumTotal>0</maximumTotal>
                            <minimumTotal />
                            <enabled>True</enabled>
                            <foreColor>
                                <r>0</r>
                                <g>0</g>
                                <b>0</b>
                            </foreColor>
                            <height>29</height>
                            <left>6</left>
                            <font>
                                <bold>True</bold>
                                <fontName>Tahoma</fontName>
                                <italic>False</italic>
                                <size>8.25</size>
                                <strikeout>False</strikeout>
                                <underline>False</underline>
                            </font>
                            <rightToLeft>0</rightToLeft>
                            <tabIndex>0</tabIndex>
                            <text>Do you have any subsidiary companies?</text>
                            <textAlign>1</textAlign>
                            <top>17</top>
                            <width>271</width>
                            <isDateDiff>0</isDateDiff>
                            <maskedEditBox />
                            <maskedEditBox2 />
                            <showData />
                            <controls />
                        </control>
                    </controls>
                </control>
                <control name="WisLabel30" type="WisLabel">
                    <sumTotalControls />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <boundTransform />
                    <description />
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>19</height>
                    <left>37</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>15</tabIndex>
                    <text>Total number of employees</text>
                    <textAlign>1</textAlign>
                    <top>677</top>
                    <width>262</width>
                    <isDateDiff>0</isDateDiff>
                    <maskedEditBox />
                    <maskedEditBox2 />
                    <showData />
                    <controls />
                </control>
                <control name="txtTotalEmployees" type="WisTextBox">
                    <LostFocusCode />
                    <GotFocusCode />
                    <ClickCode />
                    <TextChangedCode />
                    <enableControls>
                        <enableControl>
                            <boundScreen>MLIAB\frmCInfo.tst</boundScreen>
                            <control>grpWagerolls</control>
                            <enable>True</enable>
                            <symbol>Greater</symbol>
                            <threshold>10</threshold>
                        </enableControl>
                        <enableControl>
                            <boundScreen>MLIAB\frmCInfo.tst</boundScreen>
                            <control>grpERN</control>
                            <enable>True</enable>
                            <symbol>Greater</symbol>
                            <threshold>0</threshold>
                        </enableControl>
                    </enableControls>
                    <sumControls>
                        <sumControl>
                            <control>txtTotalPandP</control>
                            <symbolControl>Addition</symbolControl>
                        </sumControl>
                        <sumControl>
                            <control>txtManualEmps</control>
                            <symbolControl>Addition</symbolControl>
                        </sumControl>
                        <sumControl>
                            <control>txtManualDirectors</control>
                            <symbolControl>Addition</symbolControl>
                        </sumControl>
                        <sumControl>
                            <control>txtNonManualEmps</control>
                            <symbolControl>Addition</symbolControl>
                        </sumControl>
                        <sumControl>
                            <control>txtNonManuDirec</control>
                            <symbolControl>Addition</symbolControl>
                        </sumControl>
                    </sumControls>
                    <sumTotalControls />
                    <acceptsTab>False</acceptsTab>
                    <acceptsReturn>False</acceptsReturn>
                    <backColor>
                        <r>255</r>
                        <g>255</g>
                        <b>255</b>
                    </backColor>
                    <borderStyle>1</borderStyle>
                    <boundScreen />
                    <characterCasing>0</characterCasing>
                    <columnName>TOTALEMPLOYEES</columnName>
                    <description>Total number of employees</description>
                    <decimalPlaces>0</decimalPlaces>
                    <useDecimalPlaces>False</useDecimalPlaces>
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>21</height>
                    <left>381</left>
                    <font>
                        <bold>False</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <linkedData />
                    <maxLength>5</maxLength>
                    <multiLine>False</multiLine>
                    <numeric>True</numeric>
                    <autoIncrement>False</autoIncrement>
                    <maxAutoValue>0</maxAutoValue>
                    <properCase>False</properCase>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>11</tabIndex>
                    <text />
                    <textAlign>0</textAlign>
                    <top>677</top>
                    <width>42</width>
                    <showData />
                    <objectID>0</objectID>
                    <longPropertyID>0</longPropertyID>
                    <defaultValue />
                    <showHelpText>False</showHelpText>
                    <helpText />
                    <required>True</required>
                    <displayOnWebpage>False</displayOnWebpage>
                    <alwaysVisible>False</alwaysVisible>
                    <startYear />
                    <endYear />
                    <controls />
                </control>
                <control name="txtNonManualEmps" type="WisTextBox">
                    <LostFocusCode />
                    <GotFocusCode />
                    <ClickCode />
                    <TextChangedCode />
                    <enableControls>
                        <enableControl>
                            <boundScreen>MLIAB\frmCInfo.tst</boundScreen>
                            <control>grpWagerolls</control>
                            <enable>True</enable>
                            <symbol>Greater</symbol>
                            <threshold>10</threshold>
                        </enableControl>
                    </enableControls>
                    <sumTotalControls>
                        <sumTotalControl>
                            <control>txtTotalEmployees</control>
                        </sumTotalControl>
                    </sumTotalControls>
                    <acceptsTab>False</acceptsTab>
                    <acceptsReturn>False</acceptsReturn>
                    <backColor>
                        <r>255</r>
                        <g>255</g>
                        <b>255</b>
                    </backColor>
                    <borderStyle>1</borderStyle>
                    <boundScreen />
                    <characterCasing>0</characterCasing>
                    <columnName>NONMANUALEMPS</columnName>
                    <description>Total number of non-manual employees?</description>
                    <decimalPlaces>0</decimalPlaces>
                    <useDecimalPlaces>False</useDecimalPlaces>
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>21</height>
                    <left>381</left>
                    <font>
                        <bold>False</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <linkedData />
                    <maxLength>5</maxLength>
                    <multiLine>False</multiLine>
                    <numeric>True</numeric>
                    <autoIncrement>False</autoIncrement>
                    <maxAutoValue>0</maxAutoValue>
                    <properCase>False</properCase>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>25</tabIndex>
                    <text />
                    <textAlign>0</textAlign>
                    <top>515</top>
                    <width>42</width>
                    <showData />
                    <objectID>0</objectID>
                    <longPropertyID>0</longPropertyID>
                    <defaultValue />
                    <showHelpText>True</showHelpText>
                    <helpText>Please select the number of employees that only undertake clerical (administrative) work within your business.</helpText>
                    <required>True</required>
                    <displayOnWebpage>True</displayOnWebpage>
                    <alwaysVisible>False</alwaysVisible>
                    <startYear />
                    <endYear />
                    <controls />
                </control>
                <control name="WisLabel9" type="WisLabel">
                    <sumTotalControls />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <boundTransform />
                    <description>txtNonManualEmps</description>
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>31</height>
                    <left>6</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>0</tabIndex>
                    <text>Total number of non-manual employees?</text>
                    <textAlign>1</textAlign>
                    <top>515</top>
                    <width>354</width>
                    <isDateDiff>0</isDateDiff>
                    <maskedEditBox />
                    <maskedEditBox2 />
                    <showData />
                    <controls />
                </control>
                <control name="txtManualEmps" type="WisTextBox">
                    <LostFocusCode />
                    <GotFocusCode />
                    <ClickCode />
                    <TextChangedCode />
                    <enableControls>
                        <enableControl>
                            <boundScreen>MLIAB\frmCInfo.tst</boundScreen>
                            <control>grpWagerolls</control>
                            <enable>True</enable>
                            <symbol>Greater</symbol>
                            <threshold>10</threshold>
                        </enableControl>
                    </enableControls>
                    <sumTotalControls>
                        <sumTotalControl>
                            <control>txtTotalEmployees</control>
                        </sumTotalControl>
                    </sumTotalControls>
                    <acceptsTab>False</acceptsTab>
                    <acceptsReturn>False</acceptsReturn>
                    <backColor>
                        <r>255</r>
                        <g>255</g>
                        <b>255</b>
                    </backColor>
                    <borderStyle>1</borderStyle>
                    <boundScreen />
                    <characterCasing>0</characterCasing>
                    <columnName>MANUALEMPS</columnName>
                    <description>Total number of employees working manually</description>
                    <decimalPlaces>0</decimalPlaces>
                    <useDecimalPlaces>False</useDecimalPlaces>
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>21</height>
                    <left>381</left>
                    <font>
                        <bold>False</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <linkedData />
                    <maxLength>5</maxLength>
                    <multiLine>False</multiLine>
                    <numeric>True</numeric>
                    <autoIncrement>False</autoIncrement>
                    <maxAutoValue>0</maxAutoValue>
                    <properCase>False</properCase>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>24</tabIndex>
                    <text />
                    <textAlign>0</textAlign>
                    <top>483</top>
                    <width>42</width>
                    <showData />
                    <objectID>0</objectID>
                    <longPropertyID>0</longPropertyID>
                    <defaultValue />
                    <showHelpText>True</showHelpText>
                    <helpText>Please select the number of employees that undertake manual work regularly within your business.</helpText>
                    <required>True</required>
                    <displayOnWebpage>True</displayOnWebpage>
                    <alwaysVisible>False</alwaysVisible>
                    <startYear />
                    <endYear />
                    <controls />
                </control>
                <control name="WisLabel8" type="WisLabel">
                    <sumTotalControls />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <boundTransform />
                    <description>txtManualEmps</description>
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>43</height>
                    <left>6</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>0</tabIndex>
                    <text>Total number of employees working manually, including labour only contractors?</text>
                    <textAlign>1</textAlign>
                    <top>479</top>
                    <width>367</width>
                    <isDateDiff>0</isDateDiff>
                    <maskedEditBox />
                    <maskedEditBox2 />
                    <showData />
                    <controls />
                </control>
                <control name="txtNonManuDirec" type="WisTextBox">
                    <LostFocusCode />
                    <GotFocusCode />
                    <ClickCode />
                    <TextChangedCode />
                    <enableControls>
                        <enableControl>
                            <boundScreen>MLIAB\frmCInfo.tst</boundScreen>
                            <control>grpWagerolls</control>
                            <enable>True</enable>
                            <symbol>Greater</symbol>
                            <threshold>10</threshold>
                        </enableControl>
                    </enableControls>
                    <sumTotalControls>
                        <sumTotalControl>
                            <control>txtTotalEmployees</control>
                        </sumTotalControl>
                    </sumTotalControls>
                    <acceptsTab>False</acceptsTab>
                    <acceptsReturn>False</acceptsReturn>
                    <backColor>
                        <r>255</r>
                        <g>255</g>
                        <b>255</b>
                    </backColor>
                    <borderStyle>1</borderStyle>
                    <boundScreen />
                    <characterCasing>0</characterCasing>
                    <columnName>NONMANUDIREC</columnName>
                    <description>Total number of non-manual directors?</description>
                    <decimalPlaces>0</decimalPlaces>
                    <useDecimalPlaces>False</useDecimalPlaces>
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>21</height>
                    <left>381</left>
                    <font>
                        <bold>False</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <linkedData />
                    <maxLength>3</maxLength>
                    <multiLine>False</multiLine>
                    <numeric>True</numeric>
                    <autoIncrement>False</autoIncrement>
                    <maxAutoValue>0</maxAutoValue>
                    <properCase>False</properCase>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>23</tabIndex>
                    <text />
                    <textAlign>0</textAlign>
                    <top>450</top>
                    <width>42</width>
                    <showData />
                    <objectID>0</objectID>
                    <longPropertyID>0</longPropertyID>
                    <defaultValue />
                    <showHelpText>True</showHelpText>
                    <helpText>Please select the number of directors that only undertake clerical (administrative) work within your business.</helpText>
                    <required>True</required>
                    <displayOnWebpage>True</displayOnWebpage>
                    <alwaysVisible>False</alwaysVisible>
                    <startYear />
                    <endYear />
                    <controls />
                </control>
                <control name="WisLabel7" type="WisLabel">
                    <sumTotalControls />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <boundTransform />
                    <description>txtNonManuDirec</description>
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>32</height>
                    <left>6</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>0</tabIndex>
                    <text>Total Number of non-manual directors?</text>
                    <textAlign>1</textAlign>
                    <top>450</top>
                    <width>354</width>
                    <isDateDiff>0</isDateDiff>
                    <maskedEditBox />
                    <maskedEditBox2 />
                    <showData />
                    <controls />
                </control>
                <control name="txtManualDirectors" type="WisTextBox">
                    <LostFocusCode />
                    <GotFocusCode />
                    <ClickCode />
                    <TextChangedCode />
                    <enableControls>
                        <enableControl>
                            <boundScreen>MLIAB\frmCInfo.tst</boundScreen>
                            <control>grpWagerolls</control>
                            <enable>True</enable>
                            <symbol>Greater</symbol>
                            <threshold>10</threshold>
                        </enableControl>
                    </enableControls>
                    <sumTotalControls>
                        <sumTotalControl>
                            <control>txtTotalEmployees</control>
                        </sumTotalControl>
                    </sumTotalControls>
                    <acceptsTab>False</acceptsTab>
                    <acceptsReturn>False</acceptsReturn>
                    <backColor>
                        <r>255</r>
                        <g>255</g>
                        <b>255</b>
                    </backColor>
                    <borderStyle>1</borderStyle>
                    <boundScreen />
                    <characterCasing>0</characterCasing>
                    <columnName>MANUALDIRECTORS</columnName>
                    <description>Total number of directors working manually?</description>
                    <decimalPlaces>0</decimalPlaces>
                    <useDecimalPlaces>False</useDecimalPlaces>
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>21</height>
                    <left>381</left>
                    <font>
                        <bold>False</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <linkedData />
                    <maxLength>3</maxLength>
                    <multiLine>False</multiLine>
                    <numeric>True</numeric>
                    <autoIncrement>False</autoIncrement>
                    <maxAutoValue>0</maxAutoValue>
                    <properCase>False</properCase>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>22</tabIndex>
                    <text />
                    <textAlign>0</textAlign>
                    <top>422</top>
                    <width>42</width>
                    <showData />
                    <objectID>0</objectID>
                    <longPropertyID>0</longPropertyID>
                    <defaultValue />
                    <showHelpText>True</showHelpText>
                    <helpText>Please select the number of directors that undertake manual work regularly within your business.</helpText>
                    <required>True</required>
                    <displayOnWebpage>True</displayOnWebpage>
                    <alwaysVisible>False</alwaysVisible>
                    <startYear />
                    <endYear />
                    <controls />
                </control>
                <control name="WisLabel6" type="WisLabel">
                    <sumTotalControls />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <boundTransform />
                    <description>txtManualDirectors</description>
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>29</height>
                    <left>6</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>0</tabIndex>
                    <text>Total Number of Directors working manual?</text>
                    <textAlign>1</textAlign>
                    <top>422</top>
                    <width>354</width>
                    <isDateDiff>0</isDateDiff>
                    <maskedEditBox />
                    <maskedEditBox2 />
                    <showData />
                    <controls />
                </control>
                <control name="grpPandPs" type="GroupBox">
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>125</height>
                    <left>6</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>17</tabIndex>
                    <text>Partners and Principals</text>
                    <top>291</top>
                    <width>417</width>
                    <controls>
                        <control name="cmdPandPRemove" type="WisButton">
                            <LostFocusCode />
                            <GotFocusCode />
                            <ClickCode />
                            <backColor>
                                <r>212</r>
                                <g>208</g>
                                <b>200</b>
                            </backColor>
                            <description>Partners and Principals Remove</description>
                            <foreColor>
                                <r>0</r>
                                <g>0</g>
                                <b>0</b>
                            </foreColor>
                            <height>23</height>
                            <left>336</left>
                            <listView>lvwPandPList</listView>
                            <top>92</top>
                            <tabIndex>21</tabIndex>
                            <type>5</type>
                            <text>    &amp;Remove</text>
                            <width>75</width>
                        </control>
                        <control name="cmdPandPEdit" type="WisButton">
                            <LostFocusCode />
                            <GotFocusCode />
                            <ClickCode />
                            <backColor>
                                <r>212</r>
                                <g>208</g>
                                <b>200</b>
                            </backColor>
                            <description>Partners and Principals</description>
                            <foreColor>
                                <r>0</r>
                                <g>0</g>
                                <b>0</b>
                            </foreColor>
                            <height>23</height>
                            <left>255</left>
                            <listView>lvwPandPList</listView>
                            <top>92</top>
                            <tabIndex>20</tabIndex>
                            <type>4</type>
                            <text>  &amp;Edit</text>
                            <width>75</width>
                        </control>
                        <control name="cmdPandPAdd" type="WisButton">
                            <LostFocusCode />
                            <GotFocusCode />
                            <ClickCode />
                            <backColor>
                                <r>212</r>
                                <g>208</g>
                                <b>200</b>
                            </backColor>
                            <description>Partners and Principals Add</description>
                            <foreColor>
                                <r>0</r>
                                <g>0</g>
                                <b>0</b>
                            </foreColor>
                            <height>23</height>
                            <left>174</left>
                            <listView>lvwPandPList</listView>
                            <top>92</top>
                            <tabIndex>19</tabIndex>
                            <type>3</type>
                            <text>  &amp;Add</text>
                            <width>75</width>
                        </control>
                        <control name="lvwPandPList" type="WisListView">
                            <columns>
                                <column>
                                    <text>Title</text>
                                    <Width>40</Width>
                                    <bindControl>cboTitle</bindControl>
                                </column>
                                <column>
                                    <text>Forename</text>
                                    <Width>140</Width>
                                    <bindControl>txtForename</bindControl>
                                </column>
                                <column>
                                    <text>Surname</text>
                                    <Width>158</Width>
                                    <bindControl>txtSurname</bindControl>
                                </column>
                                <column>
                                    <text>Status</text>
                                    <Width>66</Width>
                                    <bindControl>cboStatus</bindControl>
                                </column>
                            </columns>
                            <backColor>
                                <r>255</r>
                                <g>255</g>
                                <b>255</b>
                            </backColor>
                            <borderStyle>1</borderStyle>
                            <boundScreen>MLIAB\frmPandP.tst</boundScreen>
                            <description>Partners and Principals</description>
                            <enabled>True</enabled>
                            <foreColor>
                                <r>0</r>
                                <g>0</g>
                                <b>0</b>
                            </foreColor>
                            <height>63</height>
                            <left>6</left>
                            <font>
                                <bold>False</bold>
                                <fontName>Tahoma</fontName>
                                <italic>False</italic>
                                <size>8.25</size>
                                <strikeout>False</strikeout>
                                <underline>False</underline>
                            </font>
                            <rightToLeft>0</rightToLeft>
                            <tabIndex>18</tabIndex>
                            <text />
                            <top>20</top>
                            <width>405</width>
                            <controls />
                        </control>
                    </controls>
                </control>
                <control name="txtTotalPandP" type="WisTextBox">
                    <LostFocusCode />
                    <GotFocusCode />
                    <ClickCode />
                    <TextChangedCode />
                    <enableControls />
                    <sumTotalControls>
                        <sumTotalControl>
                            <control>txtTotalEmployees</control>
                        </sumTotalControl>
                    </sumTotalControls>
                    <acceptsTab>False</acceptsTab>
                    <acceptsReturn>False</acceptsReturn>
                    <backColor>
                        <r>255</r>
                        <g>255</g>
                        <b>255</b>
                    </backColor>
                    <borderStyle>1</borderStyle>
                    <boundScreen />
                    <characterCasing>0</characterCasing>
                    <columnName>TOTALPANDP</columnName>
                    <description>Total number of Partners and Principals?</description>
                    <decimalPlaces>0</decimalPlaces>
                    <useDecimalPlaces>False</useDecimalPlaces>
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>21</height>
                    <left>381</left>
                    <font>
                        <bold>False</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <linkedData />
                    <maxLength>5</maxLength>
                    <multiLine>False</multiLine>
                    <numeric>True</numeric>
                    <autoIncrement>False</autoIncrement>
                    <maxAutoValue>0</maxAutoValue>
                    <properCase>False</properCase>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>16</tabIndex>
                    <text />
                    <textAlign>0</textAlign>
                    <top>263</top>
                    <width>42</width>
                    <showData />
                    <objectID>0</objectID>
                    <longPropertyID>0</longPropertyID>
                    <defaultValue />
                    <showHelpText>False</showHelpText>
                    <helpText />
                    <required>True</required>
                    <displayOnWebpage>True</displayOnWebpage>
                    <alwaysVisible>False</alwaysVisible>
                    <startYear />
                    <endYear />
                    <controls />
                </control>
                <control name="WisLabel5" type="WisLabel">
                    <sumTotalControls />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <boundTransform />
                    <description>txtTotalPandP</description>
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>23</height>
                    <left>6</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>0</tabIndex>
                    <text>Total number of Partners and Principals?</text>
                    <textAlign>1</textAlign>
                    <top>265</top>
                    <width>246</width>
                    <isDateDiff>0</isDateDiff>
                    <maskedEditBox />
                    <maskedEditBox2 />
                    <showData />
                    <controls />
                </control>
                <control name="optManualWork" type="tgsYesNo">
                    <LostFocusCode />
                    <GotFocusCode />
                    <ClickCode />
                    <enableControls />
                    <displayPages />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <columnName>MANUALWORK</columnName>
                    <description>Do you carry out any manual work?</description>
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>27</height>
                    <left>330</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <linkedData />
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>8</tabIndex>
                    <text />
                    <top>41</top>
                    <width>93</width>
                    <showData />
                    <objectID>0</objectID>
                    <longPropertyID>0</longPropertyID>
                    <defaultValue />
                    <showHelpText>True</showHelpText>
                    <helpText>Please specify whether you undertake manual labour.</helpText>
                    <required>True</required>
                    <displayOnWebpage>True</displayOnWebpage>
                    <alwaysVisible>False</alwaysVisible>
                    <controls />
                </control>
                <control name="lblWisLabel5" type="WisLabel">
                    <sumTotalControls />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <boundTransform />
                    <description>optManualWork</description>
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>23</height>
                    <left>6</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>0</tabIndex>
                    <text>Do you carry out any manual work?</text>
                    <textAlign>1</textAlign>
                    <top>45</top>
                    <width>209</width>
                    <isDateDiff>0</isDateDiff>
                    <maskedEditBox />
                    <maskedEditBox2 />
                    <showData />
                    <controls />
                </control>
                <control name="cboCompanyStatus" type="WisComboBox">
                    <LostFocusCode />
                    <GotFocusCode />
                    <ClickCode />
                    <TextChangedCode />
                    <SelectedIndexChangedCode />
                    <enableControls>
                        <enableControl>
                            <boundScreen>MLIAB\frmCInfo.tst</boundScreen>
                            <control>txtTotalPandP</control>
                            <enable>True</enable>
                            <listValues>
                                <listValue>3MQQN2I1</listValue>
                            </listValues>
                        </enableControl>
                        <enableControl>
                            <boundScreen>MLIAB\frmCInfo.tst</boundScreen>
                            <control>WisLabel5</control>
                            <enable>True</enable>
                            <listValues>
                                <listValue>3MQQN2I1</listValue>
                            </listValues>
                        </enableControl>
                        <enableControl>
                            <boundScreen>MLIAB\frmCInfo.tst</boundScreen>
                            <control>optManualWork</control>
                            <enable>True</enable>
                            <listValues>
                                <listValue>3MQQN2I3</listValue>
                            </listValues>
                        </enableControl>
                        <enableControl>
                            <boundScreen>MLIAB\frmCInfo.tst</boundScreen>
                            <control>lblWisLabel5</control>
                            <enable>True</enable>
                            <listValues>
                                <listValue>3MQQN2I3</listValue>
                            </listValues>
                        </enableControl>
                        <enableControl>
                            <boundScreen>MLIAB\frmCInfo.tst</boundScreen>
                            <control>txtManualDirectors</control>
                            <enable>True</enable>
                            <listValues>
                                <listValue>3MQQN2I2</listValue>
                                <listValue>3MQQN2I4</listValue>
                            </listValues>
                        </enableControl>
                        <enableControl>
                            <boundScreen>MLIAB\frmCInfo.tst</boundScreen>
                            <control>WisLabel6</control>
                            <enable>True</enable>
                            <listValues>
                                <listValue>3MQQN2I2</listValue>
                                <listValue>3MQQN2I4</listValue>
                            </listValues>
                        </enableControl>
                        <enableControl>
                            <boundScreen>MLIAB\frmCInfo.tst</boundScreen>
                            <control>txtNonManuDirec</control>
                            <enable>True</enable>
                            <listValues>
                                <listValue>3MQQN2I2</listValue>
                                <listValue>3MQQN2I4</listValue>
                            </listValues>
                        </enableControl>
                        <enableControl>
                            <boundScreen>MLIAB\frmCInfo.tst</boundScreen>
                            <control>WisLabel7</control>
                            <enable>True</enable>
                            <listValues>
                                <listValue>3MQQN2I2</listValue>
                                <listValue>3MQQN2I4</listValue>
                            </listValues>
                        </enableControl>
                        <enableControl>
                            <boundScreen>MLIAB\frmCInfo.tst</boundScreen>
                            <control>grpPandPs</control>
                            <enable>True</enable>
                            <listValues>
                                <listValue>3MQQN2I1</listValue>
                            </listValues>
                        </enableControl>
                        <enableControl>
                            <boundScreen>MLIAB\frmPandP.tst</boundScreen>
                            <control>cboStatus</control>
                            <enable>True</enable>
                            <listValues>
                                <listValue>3MQQN2I1</listValue>
                            </listValues>
                        </enableControl>
                        <enableControl>
                            <boundScreen>MLIAB\frmPandP.tst</boundScreen>
                            <control>cboTitle</control>
                            <enable>True</enable>
                            <listValues>
                                <listValue>3MQQN2I1</listValue>
                            </listValues>
                        </enableControl>
                        <enableControl>
                            <boundScreen>MLIAB\frmPandP.tst</boundScreen>
                            <control>txtForename</control>
                            <enable>True</enable>
                            <listValues>
                                <listValue>3MQQN2I1</listValue>
                            </listValues>
                        </enableControl>
                        <enableControl>
                            <boundScreen>MLIAB\frmPandP.tst</boundScreen>
                            <control>txtSurname</control>
                            <enable>True</enable>
                            <listValues>
                                <listValue>3MQQN2I1</listValue>
                            </listValues>
                        </enableControl>
                    </enableControls>
                    <backColor>
                        <r>255</r>
                        <g>255</g>
                        <b>255</b>
                    </backColor>
                    <boundScreen />
                    <columnName>MH_COSTATUS_ID</columnName>
                    <description>What is your Company Status?</description>
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>21</height>
                    <left>330</left>
                    <font>
                        <bold>False</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <linkedData />
                    <listTable>LIST_MH_COSTATUS</listTable>
                    <maxLength>0</maxLength>
                    <numeric>False</numeric>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>7</tabIndex>
                    <userFilled>False</userFilled>
                    <filteredDropdown />
                    <text />
                    <top>14</top>
                    <width>93</width>
                    <showData />
                    <objectID>0</objectID>
                    <longPropertyID>0</longPropertyID>
                    <defaultValue />
                    <showHelpText>True</showHelpText>
                    <helpText>Please select your Company Status from the list provided. Please select 'Limited' if your company is a UK company whose liability is limited by law, 'Partnership' if your company is formed as a partnership, or 'Individual Trading As' if you are a sole trader. </helpText>
                    <required>True</required>
                    <displayOnWebpage>True</displayOnWebpage>
                    <alwaysVisible>True</alwaysVisible>
                    <controls />
                </control>
                <control name="WisLabel4" type="WisLabel">
                    <sumTotalControls />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <boundTransform />
                    <description>cboCompanyStatus</description>
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>23</height>
                    <left>6</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>0</tabIndex>
                    <text>What is your Company Status?</text>
                    <textAlign>1</textAlign>
                    <top>17</top>
                    <width>186</width>
                    <isDateDiff>0</isDateDiff>
                    <maskedEditBox />
                    <maskedEditBox2 />
                    <showData />
                    <controls />
                </control>
            </controls>
        </control>
        <control name="grpCover" type="GroupBox">
            <backColor>
                <r>212</r>
                <g>208</g>
                <b>200</b>
            </backColor>
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>149</height>
            <left>10</left>
            <font>
                <bold>True</bold>
                <fontName>Tahoma</fontName>
                <italic>False</italic>
                <size>8.25</size>
                <strikeout>False</strikeout>
                <underline>False</underline>
            </font>
            <rightToLeft>0</rightToLeft>
            <tabIndex>1</tabIndex>
            <text>Cover</text>
            <top>10</top>
            <width>429</width>
            <controls>
                <control name="Optemployeetool" type="tgsYesNo">
                    <LostFocusCode />
                    <GotFocusCode />
                    <ClickCode />
                    <enableControls />
                    <displayPages />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <columnName>EMPLOYEETOOL</columnName>
                    <description>EmployeeTools</description>
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>27</height>
                    <left>330</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <linkedData />
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>4</tabIndex>
                    <text />
                    <top>75</top>
                    <width>93</width>
                    <showData />
                    <objectID>0</objectID>
                    <longPropertyID>0</longPropertyID>
                    <defaultValue />
                    <showHelpText>False</showHelpText>
                    <helpText />
                    <required>True</required>
                    <displayOnWebpage>True</displayOnWebpage>
                    <alwaysVisible>True</alwaysVisible>
                    <controls />
                </control>
                <control name="WisLabel33" type="WisLabel">
                    <sumTotalControls />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <boundTransform />
                    <description>Optemployeetool</description>
                    <maximumTotal />
                    <minimumTotal />
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>27</height>
                    <left>7</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>0</tabIndex>
                    <text>Do you want cover for your employee's tools?</text>
                    <textAlign>1</textAlign>
                    <top>84</top>
                    <width>276</width>
                    <isDateDiff>0</isDateDiff>
                    <maskedEditBox />
                    <maskedEditBox2 />
                    <showData />
                    <controls />
                </control>
                <control name="cboToolValue" type="WisComboBox">
                    <LostFocusCode />
                    <GotFocusCode />
                    <ClickCode />
                    <TextChangedCode />
                    <SelectedIndexChangedCode />
                    <enableControls />
                    <backColor>
                        <r>255</r>
                        <g>255</g>
                        <b>255</b>
                    </backColor>
                    <boundScreen />
                    <columnName>MH_COVTOOLS_ID</columnName>
                    <description>What value of tools cover would you like?</description>
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>21</height>
                    <left>330</left>
                    <font>
                        <bold>False</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <linkedData />
                    <listTable>LIST_MH_COVTOOLS</listTable>
                    <maxLength>0</maxLength>
                    <numeric>True</numeric>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>5</tabIndex>
                    <userFilled>False</userFilled>
                    <filteredDropdown />
                    <text />
                    <top>108</top>
                    <width>93</width>
                    <showData />
                    <objectID>0</objectID>
                    <longPropertyID>0</longPropertyID>
                    <defaultValue />
                    <showHelpText>False</showHelpText>
                    <helpText />
                    <required>True</required>
                    <displayOnWebpage>True</displayOnWebpage>
                    <alwaysVisible>False</alwaysVisible>
                    <controls />
                </control>
                <control name="WisLabel3" type="WisLabel">
                    <sumTotalControls />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <boundTransform />
                    <description>cboToolValue</description>
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>23</height>
                    <left>6</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>0</tabIndex>
                    <text>What value of tools cover would you like?</text>
                    <textAlign>1</textAlign>
                    <top>111</top>
                    <width>249</width>
                    <isDateDiff>0</isDateDiff>
                    <maskedEditBox />
                    <maskedEditBox2 />
                    <showData />
                    <controls />
                </control>
                <control name="optToolCover" type="tgsYesNo">
                    <LostFocusCode />
                    <GotFocusCode />
                    <ClickCode />
                    <enableControls>
                        <enableControl>
                            <boundScreen>MLIAB\frmCInfo.tst</boundScreen>
                            <control>cboToolValue</control>
                            <enable>True</enable>
                        </enableControl>
                        <enableControl>
                            <boundScreen>MLIAB\frmCInfo.tst</boundScreen>
                            <control>WisLabel3</control>
                            <enable>True</enable>
                        </enableControl>
                        <enableControl>
                            <boundScreen>MLIAB\frmCInfo.tst</boundScreen>
                            <control>Optemployeetool</control>
                            <enable>True</enable>
                        </enableControl>
                        <enableControl>
                            <boundScreen>MLIAB\frmCInfo.tst</boundScreen>
                            <control>WisLabel33</control>
                            <enable>True</enable>
                        </enableControl>
                    </enableControls>
                    <displayPages />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <columnName>TOOLCOVER</columnName>
                    <description>Do you require tools cover?</description>
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>27</height>
                    <left>330</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <linkedData />
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>3</tabIndex>
                    <text />
                    <top>43</top>
                    <width>93</width>
                    <showData />
                    <objectID>0</objectID>
                    <longPropertyID>0</longPropertyID>
                    <defaultValue />
                    <showHelpText>True</showHelpText>
                    <helpText>This covers your hand tools &amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp; power tools in the event of loss, theft or accidental damage. Cover can be provided for up to £5,000.</helpText>
                    <required>True</required>
                    <displayOnWebpage>True</displayOnWebpage>
                    <alwaysVisible>False</alwaysVisible>
                    <controls />
                </control>
                <control name="WisLabel2" type="WisLabel">
                    <sumTotalControls />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <boundTransform />
                    <description>optToolCover</description>
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>27</height>
                    <left>6</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>0</tabIndex>
                    <text>Do you require tools cover?</text>
                    <textAlign>16</textAlign>
                    <top>45</top>
                    <width>186</width>
                    <isDateDiff>0</isDateDiff>
                    <maskedEditBox />
                    <maskedEditBox2 />
                    <showData />
                    <controls />
                </control>
                <control name="cboPubLiabLimit" type="WisComboBox">
                    <LostFocusCode />
                    <GotFocusCode />
                    <ClickCode />
                    <TextChangedCode />
                    <SelectedIndexChangedCode />
                    <enableControls />
                    <backColor>
                        <r>255</r>
                        <g>255</g>
                        <b>255</b>
                    </backColor>
                    <boundScreen />
                    <columnName>MH_PUBLIAB_ID</columnName>
                    <description>What Public Liability Limit do you require?</description>
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>21</height>
                    <left>330</left>
                    <font>
                        <bold>False</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <linkedData />
                    <listTable>LIST_MH_PUBLIAB</listTable>
                    <maxLength>0</maxLength>
                    <numeric>True</numeric>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>2</tabIndex>
                    <userFilled>False</userFilled>
                    <filteredDropdown />
                    <text />
                    <top>17</top>
                    <width>93</width>
                    <showData />
                    <objectID>0</objectID>
                    <longPropertyID>0</longPropertyID>
                    <defaultValue />
                    <showHelpText>True</showHelpText>
                    <helpText>Public liability insurance covers against death or bodily injury to third party persons, or against the loss of, or damage to, third party property arising from your business operations. The Public Liability Limit is the maximum sum that the insurer will pay for any event, occurrence or accident in any one year.</helpText>
                    <required>True</required>
                    <displayOnWebpage>True</displayOnWebpage>
                    <alwaysVisible>True</alwaysVisible>
                    <controls />
                </control>
                <control name="WisLabel1" type="WisLabel">
                    <sumTotalControls />
                    <backColor>
                        <r>212</r>
                        <g>208</g>
                        <b>200</b>
                    </backColor>
                    <borderStyle>0</borderStyle>
                    <boundScreen />
                    <boundTransform />
                    <description>cboPubLiabLimit</description>
                    <maximumTotal>0</maximumTotal>
                    <minimumTotal />
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>23</height>
                    <left>6</left>
                    <font>
                        <bold>True</bold>
                        <fontName>Tahoma</fontName>
                        <italic>False</italic>
                        <size>8.25</size>
                        <strikeout>False</strikeout>
                        <underline>False</underline>
                    </font>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>0</tabIndex>
                    <text>What Public Liability Limit do you require?</text>
                    <textAlign>1</textAlign>
                    <top>20</top>
                    <width>248</width>
                    <isDateDiff>0</isDateDiff>
                    <maskedEditBox />
                    <maskedEditBox2 />
                    <showData />
                    <controls />
                </control>
            </controls>
        </control>
    </controls>
    <generalSummary>
        <columns />
    </generalSummary>
    <formValidation>
        <validation>
            <controlToValidate>txtTotalPandP</controlToValidate>
            <operatorType>Not Equal To</operatorType>
            <comparisonType>ObjectCount</comparisonType>
            <validationValue>MLIAB\frmPandP.tst,Add,0</validationValue>
            <displayMessage>Please validate Partners and Principals</displayMessage>
        </validation>
    </formValidation>
    <hideClaim />
</screen>