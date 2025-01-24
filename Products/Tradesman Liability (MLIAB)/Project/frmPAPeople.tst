<?xml version="1.0" encoding="utf-8"?>
<screen name="frmPAPeople.tst" type="NextPrevious">
    <backColor>
        <r>212</r>
        <g>208</g>
        <b>200</b>
    </backColor>
    <boundScreen />
    <caption>Personal Accident and Income People</caption>
    <description>Personal Accident and Income People</description>
    <screenType>0</screenType>
    <projectType>1</projectType>
    <postQuoteNavigationDuplicated>False</postQuoteNavigationDuplicated>
    <foreColor>
        <r>0</r>
        <g>0</g>
        <b>0</b>
    </foreColor>
    <height>345</height>
    <parentID />
    <text>Personal Accident and Income People</text>
    <width>430</width>
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
        <control name="cboTitle" type="WisComboBox">
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
            <columnName>TITLE_ID</columnName>
            <description>Title</description>
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>21</height>
            <left>137</left>
            <font>
                <bold>False</bold>
                <fontName>Tahoma</fontName>
                <italic>False</italic>
                <size>8.25</size>
                <strikeout>False</strikeout>
                <underline>False</underline>
            </font>
            <linkedData />
            <listTable>LIST_TITLE</listTable>
            <maxLength>0</maxLength>
            <numeric>False</numeric>
            <rightToLeft>0</rightToLeft>
            <tabIndex>1</tabIndex>
            <userFilled>False</userFilled>
            <filteredDropdown />
            <text />
            <top>52</top>
            <width>200</width>
            <showData />
            <objectID>0</objectID>
            <longPropertyID>0</longPropertyID>
            <defaultValue />
            <showHelpText>True</showHelpText>
            <helpText>Mr, Mrs, Dr etc..</helpText>
            <required>True</required>
            <displayOnWebpage>True</displayOnWebpage>
            <alwaysVisible>True</alwaysVisible>
            <controls />
        </control>
        <control name="optUKResidentYN" type="tgsYesNo">
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
            <columnName>UKRESIDENTYN</columnName>
            <description>optUKResidentYN</description>
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>39</height>
            <left>281</left>
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
            <tabIndex>5</tabIndex>
            <text />
            <top>201</top>
            <width>99</width>
            <showData />
            <objectID>0</objectID>
            <longPropertyID>0</longPropertyID>
            <defaultValue />
            <showHelpText>True</showHelpText>
            <helpText>Permanent resident of the UK</helpText>
            <required>True</required>
            <displayOnWebpage>True</displayOnWebpage>
            <alwaysVisible>True</alwaysVisible>
            <controls />
        </control>
        <control name="mskDateOfBirth" type="WisMaskedBox">
            <LostFocusCode />
            <GotFocusCode />
            <ClickCode />
            <dateRestriction>Unrestricted</dateRestriction>
            <cultureInfo>en-GB</cultureInfo>
            <displayFormat>dd/MM/yyyy</displayFormat>
            <startYear>0</startYear>
            <endYear>0</endYear>
            <reverseList>False</reverseList>
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
            <columnName>DATEOFBIRTH</columnName>
            <description>DateOfBirth</description>
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>21</height>
            <left>137</left>
            <font>
                <bold>False</bold>
                <fontName>Tahoma</fontName>
                <italic>False</italic>
                <size>8.25</size>
                <strikeout>False</strikeout>
                <underline>False</underline>
            </font>
            <linkedData />
            <mask>##/##/####</mask>
            <maxLength>32767</maxLength>
            <multiLine>False</multiLine>
            <numeric>False</numeric>
            <rightToLeft>0</rightToLeft>
            <tabIndex>4</tabIndex>
            <text>__/__/____</text>
            <textAlign>0</textAlign>
            <top>167</top>
            <width>78</width>
            <boundObject>0</boundObject>
            <showData />
            <objectID>0</objectID>
            <longPropertyID>0</longPropertyID>
            <defaultValue />
            <showHelpText>True</showHelpText>
            <helpText>Date of Birth</helpText>
            <required>True</required>
            <displayOnWebpage>True</displayOnWebpage>
            <alwaysVisible>True</alwaysVisible>
            <controls />
        </control>
        <control name="txtSurname" type="WisTextBox">
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
            <columnName>SURNAME</columnName>
            <description>Surname</description>
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
            <left>137</left>
            <font>
                <bold>False</bold>
                <fontName>Tahoma</fontName>
                <italic>False</italic>
                <size>8.25</size>
                <strikeout>False</strikeout>
                <underline>False</underline>
            </font>
            <linkedData />
            <maxLength>50</maxLength>
            <multiLine>False</multiLine>
            <numeric>False</numeric>
            <autoIncrement>False</autoIncrement>
            <maxAutoValue>0</maxAutoValue>
            <properCase>False</properCase>
            <rightToLeft>0</rightToLeft>
            <tabIndex>3</tabIndex>
            <text />
            <textAlign>0</textAlign>
            <top>127</top>
            <width>200</width>
            <showData />
            <objectID>0</objectID>
            <longPropertyID>0</longPropertyID>
            <defaultValue />
            <showHelpText>True</showHelpText>
            <helpText>Last Name</helpText>
            <required>True</required>
            <displayOnWebpage>True</displayOnWebpage>
            <alwaysVisible>True</alwaysVisible>
            <startYear />
            <endYear />
            <controls />
        </control>
        <control name="txtForenames" type="WisTextBox">
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
            <columnName>FORENAMES</columnName>
            <description>Forenames</description>
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
            <left>137</left>
            <font>
                <bold>False</bold>
                <fontName>Tahoma</fontName>
                <italic>False</italic>
                <size>8.25</size>
                <strikeout>False</strikeout>
                <underline>False</underline>
            </font>
            <linkedData />
            <maxLength>50</maxLength>
            <multiLine>False</multiLine>
            <numeric>False</numeric>
            <autoIncrement>False</autoIncrement>
            <maxAutoValue>0</maxAutoValue>
            <properCase>False</properCase>
            <rightToLeft>0</rightToLeft>
            <tabIndex>2</tabIndex>
            <text />
            <textAlign>0</textAlign>
            <top>89</top>
            <width>200</width>
            <showData />
            <objectID>0</objectID>
            <longPropertyID>0</longPropertyID>
            <defaultValue />
            <showHelpText>True</showHelpText>
            <helpText>First Name</helpText>
            <required>True</required>
            <displayOnWebpage>True</displayOnWebpage>
            <alwaysVisible>True</alwaysVisible>
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
            <description>optUKResidentYN</description>
            <maximumTotal />
            <minimumTotal />
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>39</height>
            <left>38</left>
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
            <text>Are you Permanently resident in the UK?</text>
            <textAlign>1</textAlign>
            <top>212</top>
            <width>237</width>
            <isDateDiff>0</isDateDiff>
            <maskedEditBox />
            <maskedEditBox2 />
            <showData />
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
            <description>mskDateOfBirth</description>
            <maximumTotal />
            <minimumTotal />
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>29</height>
            <left>38</left>
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
            <text>Date Of Birth</text>
            <textAlign>1</textAlign>
            <top>169</top>
            <width>121</width>
            <isDateDiff>0</isDateDiff>
            <maskedEditBox />
            <maskedEditBox2 />
            <showData />
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
            <description>txtSurname</description>
            <maximumTotal />
            <minimumTotal />
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>31</height>
            <left>38</left>
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
            <text>Surname</text>
            <textAlign>1</textAlign>
            <top>127</top>
            <width>143</width>
            <isDateDiff>0</isDateDiff>
            <maskedEditBox />
            <maskedEditBox2 />
            <showData />
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
            <description>txtForenames</description>
            <maximumTotal />
            <minimumTotal />
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>29</height>
            <left>38</left>
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
            <text>Forenames</text>
            <textAlign>1</textAlign>
            <top>89</top>
            <width>87</width>
            <isDateDiff>0</isDateDiff>
            <maskedEditBox />
            <maskedEditBox2 />
            <showData />
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
            <description>cboTitle</description>
            <maximumTotal />
            <minimumTotal />
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>17</height>
            <left>38</left>
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
            <text>Title</text>
            <textAlign>1</textAlign>
            <top>55</top>
            <width>96</width>
            <isDateDiff>0</isDateDiff>
            <maskedEditBox />
            <maskedEditBox2 />
            <showData />
            <controls />
        </control>
    </controls>
    <generalSummary>
        <columns>
            <column>
                <text>Title</text>
                <bindControl>cboTitle</bindControl>
            </column>
            <column>
                <text>Forenames</text>
                <bindControl>txtForenames</bindControl>
            </column>
            <column>
                <text>Surname</text>
                <bindControl>txtSurname</bindControl>
            </column>
            <column>
                <text>Date Of Birth</text>
                <bindControl>mskDateOfBirth</bindControl>
            </column>
            <column>
                <text>UK Resident</text>
                <bindControl>optUKResidentYN</bindControl>
            </column>
        </columns>
    </generalSummary>
    <formValidation />
    <hideClaim />
</screen>