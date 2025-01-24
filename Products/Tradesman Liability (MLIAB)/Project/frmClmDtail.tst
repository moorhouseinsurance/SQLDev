<?xml version="1.0" encoding="utf-8"?>
<screen name="frmClmDtail.tst" type="NextPrevious">
    <backColor>
        <r>212</r>
        <g>208</g>
        <b>200</b>
    </backColor>
    <boundScreen />
    <caption>Claim Detail</caption>
    <description>Claim Detail</description>
    <screenType>0</screenType>
    <projectType>1</projectType>
    <postQuoteNavigationDuplicated>False</postQuoteNavigationDuplicated>
    <foreColor>
        <r>0</r>
        <g>0</g>
        <b>0</b>
    </foreColor>
    <height>289</height>
    <parentID />
    <text>Liability: Claim Detail</text>
    <width>465</width>
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
        <control name="txtDetails" type="WisTextBox">
            <LostFocusCode />
            <GotFocusCode />
            <ClickCode />
            <TextChangedCode />
            <enableControls />
            <sumTotalControls />
            <acceptsTab>False</acceptsTab>
            <acceptsReturn>True</acceptsReturn>
            <backColor>
                <r>255</r>
                <g>255</g>
                <b>255</b>
            </backColor>
            <borderStyle>1</borderStyle>
            <boundScreen />
            <characterCasing>0</characterCasing>
            <columnName>DETAILS</columnName>
            <description>Please provide details:</description>
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
            <height>53</height>
            <left>10</left>
            <font>
                <bold>False</bold>
                <fontName>Tahoma</fontName>
                <italic>False</italic>
                <size>8.25</size>
                <strikeout>False</strikeout>
                <underline>False</underline>
            </font>
            <linkedData />
            <maxLength>500</maxLength>
            <multiLine>True</multiLine>
            <numeric>False</numeric>
            <autoIncrement>False</autoIncrement>
            <maxAutoValue>0</maxAutoValue>
            <properCase>False</properCase>
            <rightToLeft>0</rightToLeft>
            <tabIndex>5</tabIndex>
            <text />
            <textAlign>0</textAlign>
            <top>152</top>
            <width>433</width>
            <showData />
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
            <description>txtDetails</description>
            <maximumTotal>0</maximumTotal>
            <minimumTotal />
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>23</height>
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
            <tabIndex>0</tabIndex>
            <text>Please provide details:</text>
            <textAlign>1</textAlign>
            <top>135</top>
            <width>142</width>
            <isDateDiff>0</isDateDiff>
            <maskedEditBox />
            <maskedEditBox2 />
            <showData />
            <controls />
        </control>
        <control name="cfdOutstanding" type="tgsCurrencyField">
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
            <columnName>OUTSTANDING</columnName>
            <codeEnabled>False</codeEnabled>
            <description>What is the accident / loss amount outstanding?</description>
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
            <left>299</left>
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
            <tabIndex>4</tabIndex>
            <text />
            <top>103</top>
            <width>144</width>
            <sumInsured>False</sumInsured>
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
            <description>cfdOutstanding</description>
            <maximumTotal>0</maximumTotal>
            <minimumTotal />
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>23</height>
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
            <tabIndex>0</tabIndex>
            <text>What is the accident / loss amount outstanding?</text>
            <textAlign>1</textAlign>
            <top>103</top>
            <width>293</width>
            <isDateDiff>0</isDateDiff>
            <maskedEditBox />
            <maskedEditBox2 />
            <showData />
            <controls />
        </control>
        <control name="cfdPaid" type="tgsCurrencyField">
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
            <columnName>PAID</columnName>
            <codeEnabled>False</codeEnabled>
            <description>What is the accident / loss amount paid?</description>
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
            <left>299</left>
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
            <tabIndex>3</tabIndex>
            <text />
            <top>76</top>
            <width>144</width>
            <sumInsured>False</sumInsured>
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
            <description>cfdPaid</description>
            <maximumTotal>0</maximumTotal>
            <minimumTotal />
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>23</height>
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
            <tabIndex>0</tabIndex>
            <text>What is the accident / loss amount paid?</text>
            <textAlign>1</textAlign>
            <top>76</top>
            <width>244</width>
            <isDateDiff>0</isDateDiff>
            <maskedEditBox />
            <maskedEditBox2 />
            <showData />
            <controls />
        </control>
        <control name="mskDate" type="WisMaskedBox">
            <LostFocusCode />
            <GotFocusCode />
            <ClickCode />
            <dateRestriction>Current Date</dateRestriction>
            <cultureInfo>en-GB</cultureInfo>
            <displayFormat>dd/MM/yyyy</displayFormat>
            <startYear>0</startYear>
            <endYear>-5</endYear>
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
            <columnName>DATE</columnName>
            <description>What is the claim accident / loss date?</description>
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>21</height>
            <left>323</left>
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
            <maxLength>8</maxLength>
            <multiLine>False</multiLine>
            <numeric>False</numeric>
            <rightToLeft>0</rightToLeft>
            <tabIndex>2</tabIndex>
            <text>__/__/____</text>
            <textAlign>0</textAlign>
            <top>47</top>
            <width>65</width>
            <boundObject>0</boundObject>
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
            <description>mskDate</description>
            <maximumTotal>0</maximumTotal>
            <minimumTotal />
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>23</height>
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
            <tabIndex>0</tabIndex>
            <text>What is the claim accident / loss date?</text>
            <textAlign>1</textAlign>
            <top>49</top>
            <width>227</width>
            <isDateDiff>0</isDateDiff>
            <maskedEditBox />
            <maskedEditBox2 />
            <showData />
            <controls />
        </control>
        <control name="cboType" type="WisComboBox">
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
            <columnName>MH_CLAIMTYPE_ID</columnName>
            <description>What is the type of claim?</description>
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>21</height>
            <left>322</left>
            <font>
                <bold>False</bold>
                <fontName>Tahoma</fontName>
                <italic>False</italic>
                <size>8.25</size>
                <strikeout>False</strikeout>
                <underline>False</underline>
            </font>
            <linkedData />
            <listTable>LIST_MH_CLAIMTYPE</listTable>
            <maxLength>0</maxLength>
            <numeric>False</numeric>
            <rightToLeft>0</rightToLeft>
            <tabIndex>1</tabIndex>
            <userFilled>False</userFilled>
            <filteredDropdown />
            <text />
            <top>20</top>
            <width>121</width>
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
            <description>cboType</description>
            <maximumTotal>0</maximumTotal>
            <minimumTotal />
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>23</height>
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
            <tabIndex>0</tabIndex>
            <text>What is the type of claim?</text>
            <textAlign>1</textAlign>
            <top>23</top>
            <width>163</width>
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
                <text>Type of Claim</text>
                <bindControl>cboType</bindControl>
            </column>
            <column>
                <text>Claim Date</text>
                <bindControl>mskDate</bindControl>
            </column>
            <column>
                <text>Amount paid</text>
                <bindControl>cfdPaid</bindControl>
            </column>
            <column>
                <text>Amount Outstanding</text>
                <bindControl>cfdOutstanding</bindControl>
            </column>
        </columns>
    </generalSummary>
    <formValidation>
        <validation>
            <controlToValidate>mskDate</controlToValidate>
            <operatorType>Greater Than</operatorType>
            <comparisonType>SystemDate</comparisonType>
            <validationValue>Policy Start Date</validationValue>
            <displayMessage>Claim can't be added after policy start date</displayMessage>
        </validation>
    </formValidation>
    <hideClaim />
</screen>