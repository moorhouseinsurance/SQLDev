<?xml version="1.0" encoding="utf-8"?>
<screen name="frmELTO.tst" type="NextPrevious">
    <backColor>
        <r>212</r>
        <g>208</g>
        <b>200</b>
    </backColor>
    <boundScreen />
    <caption>ELTO PQ Screen</caption>
    <description>ELTO PQ Screen</description>
    <screenType>7</screenType>
    <projectType>1</projectType>
    <postQuoteNavigationDuplicated>False</postQuoteNavigationDuplicated>
    <foreColor>
        <r>0</r>
        <g>0</g>
        <b>0</b>
    </foreColor>
    <height>161</height>
    <parentID />
    <text>ELTO PQ</text>
    <width>484</width>
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
        <control name="txtTotalEmployees" type="WisTextBox">
            <LostFocusCode />
            <GotFocusCode />
            <ClickCode />
            <TextChangedCode />
            <enableControls>
                <enableControl>
                    <boundScreen>MLIAB\frmELTO.tst</boundScreen>
                    <control>grpERN</control>
                    <enable>True</enable>
                    <symbol>Greater</symbol>
                    <threshold>0</threshold>
                </enableControl>
            </enableControls>
            <sumTotalControls />
            <acceptsTab>False</acceptsTab>
            <acceptsReturn>False</acceptsReturn>
            <backColor>
                <r>255</r>
                <g>255</g>
                <b>255</b>
            </backColor>
            <borderStyle>1</borderStyle>
            <boundScreen>MLIAB\frmCInfo.tst</boundScreen>
            <characterCasing>0</characterCasing>
            <columnName>TOTALEMPLOYEES</columnName>
            <description>Total number of employees</description>
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
            <left>354</left>
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
            <tabIndex>1</tabIndex>
            <text />
            <textAlign>0</textAlign>
            <top>97</top>
            <width>100</width>
            <showData>txtTotalEmployees</showData>
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
            <height>81</height>
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
            <tabIndex>2</tabIndex>
            <text>ELTO</text>
            <top>10</top>
            <width>459</width>
            <controls>
                <control name="chkERNExempt" type="WisCheckBox">
                    <LostFocusCode />
                    <GotFocusCode />
                    <ClickCode />
                    <enableControls>
                        <enableControl>
                            <boundScreen>MLIAB\frmELTO.tst</boundScreen>
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
                    <boundScreen>MLIAB\frmCInfo.tst</boundScreen>
                    <columnName>ERNEXEMPT</columnName>
                    <description>ERNExempt</description>
                    <enabled>True</enabled>
                    <foreColor>
                        <r>0</r>
                        <g>0</g>
                        <b>0</b>
                    </foreColor>
                    <height>24</height>
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
                    <rightToLeft>1</rightToLeft>
                    <tabIndex>4</tabIndex>
                    <checkAlign>16</checkAlign>
                    <text>ERN Exempt</text>
                    <textAlign>16</textAlign>
                    <top>44</top>
                    <width>104</width>
                    <showData>chkERNExempt</showData>
                    <objectID>0</objectID>
                    <longPropertyID>0</longPropertyID>
                    <defaultValue />
                    <showHelpText>False</showHelpText>
                    <helpText />
                    <required>True</required>
                    <displayOnWebpage>True</displayOnWebpage>
                    <alwaysVisible>True</alwaysVisible>
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
                    <boundScreen>MLIAB\frmCInfo.tst</boundScreen>
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
                    <maxLength>32767</maxLength>
                    <multiLine>False</multiLine>
                    <numeric>False</numeric>
                    <autoIncrement>False</autoIncrement>
                    <maxAutoValue>0</maxAutoValue>
                    <properCase>False</properCase>
                    <rightToLeft>0</rightToLeft>
                    <tabIndex>3</tabIndex>
                    <text />
                    <textAlign>0</textAlign>
                    <top>17</top>
                    <width>100</width>
                    <showData>txtERNRef</showData>
                    <objectID>0</objectID>
                    <longPropertyID>0</longPropertyID>
                    <defaultValue />
                    <showHelpText>False</showHelpText>
                    <helpText />
                    <required>True</required>
                    <displayOnWebpage>True</displayOnWebpage>
                    <alwaysVisible>True</alwaysVisible>
                    <startYear />
                    <endYear />
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
                    <description />
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
                    <text>Total number of employees working manually, including labour only contractors?</text>
                    <textAlign>1</textAlign>
                    <top>17</top>
                    <width>358</width>
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
    <formValidation />
</screen>