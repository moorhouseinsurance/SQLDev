<?xml version="1.0" encoding="utf-8"?>
<screen name="frmBusSupp.tst" type="NextPrevious">
    <backColor>
        <r>212</r>
        <g>208</g>
        <b>200</b>
    </backColor>
    <boundScreen />
    <caption>Business Support</caption>
    <description>Business Support</description>
    <screenType>0</screenType>
    <projectType>1</projectType>
    <postQuoteNavigationDuplicated>False</postQuoteNavigationDuplicated>
    <foreColor>
        <r>0</r>
        <g>0</g>
        <b>0</b>
    </foreColor>
    <height>387</height>
    <parentID />
    <text>Liability: Business Support</text>
    <width>965</width>
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
        <control name="txtHandSDetails" type="WisTextBox">
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
            <columnName>HANDSDETAILS</columnName>
            <description>If yes, please provide details</description>
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
            <left>671</left>
            <font>
                <bold>False</bold>
                <fontName>Tahoma</fontName>
                <italic>False</italic>
                <size>8.25</size>
                <strikeout>False</strikeout>
                <underline>False</underline>
            </font>
            <linkedData />
            <maxLength>100</maxLength>
            <multiLine>False</multiLine>
            <numeric>False</numeric>
            <autoIncrement>False</autoIncrement>
            <maxAutoValue>0</maxAutoValue>
            <properCase>False</properCase>
            <rightToLeft>0</rightToLeft>
            <tabIndex>14</tabIndex>
            <text />
            <textAlign>0</textAlign>
            <top>231</top>
            <width>246</width>
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
            <description>txtHandSDetails</description>
            <maximumTotal>0</maximumTotal>
            <minimumTotal />
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>23</height>
            <left>474</left>
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
            <text>If yes, please provide details</text>
            <textAlign>1</textAlign>
            <top>233</top>
            <width>183</width>
            <isDateDiff>0</isDateDiff>
            <maskedEditBox />
            <maskedEditBox2 />
            <showData />
            <controls />
        </control>
        <control name="optHandS" type="tgsYesNo">
            <LostFocusCode />
            <GotFocusCode />
            <ClickCode />
            <enableControls>
                <enableControl>
                    <boundScreen>MLIAB\frmBusSupp.tst</boundScreen>
                    <control>WisLabel14</control>
                    <enable>True</enable>
                </enableControl>
                <enableControl>
                    <boundScreen>MLIAB\frmBusSupp.tst</boundScreen>
                    <control>txtHandSDetails</control>
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
            <columnName>HANDS</columnName>
            <description>prosecution under the health and safety</description>
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>27</height>
            <left>823</left>
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
            <tabIndex>13</tabIndex>
            <text />
            <top>180</top>
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
            <description>optHandS</description>
            <maximumTotal>0</maximumTotal>
            <minimumTotal />
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>45</height>
            <left>474</left>
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
            <text>Have you been the subject of a prosecution under the health and safety at work act 1974, or been the subject of an improvement or prohibition notice in the last 3 years?</text>
            <textAlign>1</textAlign>
            <top>180</top>
            <width>343</width>
            <isDateDiff>0</isDateDiff>
            <maskedEditBox />
            <maskedEditBox2 />
            <showData />
            <controls />
        </control>
        <control name="txtTribunalDetails" type="WisTextBox">
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
            <columnName>TRIBUNALDETAILS</columnName>
            <description>If yes, please provide details</description>
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
            <left>671</left>
            <font>
                <bold>False</bold>
                <fontName>Tahoma</fontName>
                <italic>False</italic>
                <size>8.25</size>
                <strikeout>False</strikeout>
                <underline>False</underline>
            </font>
            <linkedData />
            <maxLength>100</maxLength>
            <multiLine>False</multiLine>
            <numeric>False</numeric>
            <autoIncrement>False</autoIncrement>
            <maxAutoValue>0</maxAutoValue>
            <properCase>False</properCase>
            <rightToLeft>0</rightToLeft>
            <tabIndex>12</tabIndex>
            <text />
            <textAlign>0</textAlign>
            <top>152</top>
            <width>246</width>
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
            <description>txtTribunalDetails</description>
            <maximumTotal>0</maximumTotal>
            <minimumTotal />
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>23</height>
            <left>474</left>
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
            <text>If yes, please provide details</text>
            <textAlign>1</textAlign>
            <top>154</top>
            <width>174</width>
            <isDateDiff>0</isDateDiff>
            <maskedEditBox />
            <maskedEditBox2 />
            <showData />
            <controls />
        </control>
        <control name="optTribunal" type="tgsYesNo">
            <LostFocusCode />
            <GotFocusCode />
            <ClickCode />
            <enableControls>
                <enableControl>
                    <boundScreen>MLIAB\frmBusSupp.tst</boundScreen>
                    <control>WisLabel12</control>
                    <enable>True</enable>
                </enableControl>
                <enableControl>
                    <boundScreen>MLIAB\frmBusSupp.tst</boundScreen>
                    <control>txtTribunalDetails</control>
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
            <columnName>TRIBUNAL</columnName>
            <description>employment tribunal or court proceedings</description>
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>27</height>
            <left>824</left>
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
            <top>102</top>
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
            <description>optTribunal</description>
            <maximumTotal>0</maximumTotal>
            <minimumTotal />
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>43</height>
            <left>474</left>
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
            <text>Has your company been subject to any employment Tribunal or court proceedings in respect of any employment dispute within the last 3 years?</text>
            <textAlign>1</textAlign>
            <top>102</top>
            <width>326</width>
            <isDateDiff>0</isDateDiff>
            <maskedEditBox />
            <maskedEditBox2 />
            <showData />
            <controls />
        </control>
        <control name="txtDiscussDetails" type="WisTextBox">
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
            <columnName>DISCUSSDETAILS</columnName>
            <description>If yes, please provide details</description>
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
            <left>671</left>
            <font>
                <bold>False</bold>
                <fontName>Tahoma</fontName>
                <italic>False</italic>
                <size>8.25</size>
                <strikeout>False</strikeout>
                <underline>False</underline>
            </font>
            <linkedData />
            <maxLength>100</maxLength>
            <multiLine>False</multiLine>
            <numeric>False</numeric>
            <autoIncrement>False</autoIncrement>
            <maxAutoValue>0</maxAutoValue>
            <properCase>False</properCase>
            <rightToLeft>0</rightToLeft>
            <tabIndex>10</tabIndex>
            <text />
            <textAlign>0</textAlign>
            <top>75</top>
            <width>246</width>
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
            <description>txtDiscussDetails</description>
            <maximumTotal>0</maximumTotal>
            <minimumTotal />
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>23</height>
            <left>474</left>
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
            <text>If yes, please provide details</text>
            <textAlign>1</textAlign>
            <top>77</top>
            <width>174</width>
            <isDateDiff>0</isDateDiff>
            <maskedEditBox />
            <maskedEditBox2 />
            <showData />
            <controls />
        </control>
        <control name="optDiscussions" type="tgsYesNo">
            <LostFocusCode />
            <GotFocusCode />
            <ClickCode />
            <enableControls>
                <enableControl>
                    <boundScreen>MLIAB\frmBusSupp.tst</boundScreen>
                    <control>WisLabel10</control>
                    <enable>True</enable>
                </enableControl>
                <enableControl>
                    <boundScreen>MLIAB\frmBusSupp.tst</boundScreen>
                    <control>txtDiscussDetails</control>
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
            <columnName>DISCUSSIONS</columnName>
            <description>discussions with any party in respect of</description>
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>27</height>
            <left>824</left>
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
            <tabIndex>9</tabIndex>
            <text />
            <top>20</top>
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
            <description>optDiscussions</description>
            <maximumTotal>0</maximumTotal>
            <minimumTotal />
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>47</height>
            <left>474</left>
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
            <text>Are you, or have you been in correspondence or discussions with any party in respect of a potential or actual employment dispute within the last 60 days?</text>
            <textAlign>1</textAlign>
            <top>20</top>
            <width>326</width>
            <isDateDiff>0</isDateDiff>
            <maskedEditBox />
            <maskedEditBox2 />
            <showData />
            <controls />
        </control>
        <control name="txtReguDetails" type="WisTextBox">
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
            <columnName>REGUDETAILS</columnName>
            <description>If yes, please provide details</description>
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
            <left>207</left>
            <font>
                <bold>False</bold>
                <fontName>Tahoma</fontName>
                <italic>False</italic>
                <size>8.25</size>
                <strikeout>False</strikeout>
                <underline>False</underline>
            </font>
            <linkedData />
            <maxLength>100</maxLength>
            <multiLine>False</multiLine>
            <numeric>False</numeric>
            <autoIncrement>False</autoIncrement>
            <maxAutoValue>0</maxAutoValue>
            <properCase>False</properCase>
            <rightToLeft>0</rightToLeft>
            <tabIndex>8</tabIndex>
            <text />
            <textAlign>0</textAlign>
            <top>282</top>
            <width>246</width>
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
            <description>txtReguDetails</description>
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
            <text>If yes, please provide details</text>
            <textAlign>1</textAlign>
            <top>284</top>
            <width>174</width>
            <isDateDiff>0</isDateDiff>
            <maskedEditBox />
            <maskedEditBox2 />
            <showData />
            <controls />
        </control>
        <control name="optRegulations" type="tgsYesNo">
            <LostFocusCode />
            <GotFocusCode />
            <ClickCode />
            <enableControls>
                <enableControl>
                    <boundScreen>MLIAB\frmBusSupp.tst</boundScreen>
                    <control>WisLabel8</control>
                    <enable>True</enable>
                </enableControl>
                <enableControl>
                    <boundScreen>MLIAB\frmBusSupp.tst</boundScreen>
                    <control>txtReguDetails</control>
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
            <columnName>REGULATIONS</columnName>
            <description>breaching any employment regulations</description>
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>27</height>
            <left>360</left>
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
            <tabIndex>7</tabIndex>
            <text />
            <top>233</top>
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
            <description>optRegulations</description>
            <maximumTotal>0</maximumTotal>
            <minimumTotal />
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>44</height>
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
            <text>Over the last 3 years has your company been prosecuted for breaching any employment regulations or are such prosecutions pending?</text>
            <textAlign>1</textAlign>
            <top>233</top>
            <width>326</width>
            <isDateDiff>0</isDateDiff>
            <maskedEditBox />
            <maskedEditBox2 />
            <showData />
            <controls />
        </control>
        <control name="txtRedunDetails" type="WisTextBox">
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
            <columnName>REDUNDETAILS</columnName>
            <description>If yes, please provide details</description>
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
            <left>207</left>
            <font>
                <bold>False</bold>
                <fontName>Tahoma</fontName>
                <italic>False</italic>
                <size>8.25</size>
                <strikeout>False</strikeout>
                <underline>False</underline>
            </font>
            <linkedData />
            <maxLength>100</maxLength>
            <multiLine>False</multiLine>
            <numeric>False</numeric>
            <autoIncrement>False</autoIncrement>
            <maxAutoValue>0</maxAutoValue>
            <properCase>False</properCase>
            <rightToLeft>0</rightToLeft>
            <tabIndex>6</tabIndex>
            <text />
            <textAlign>0</textAlign>
            <top>206</top>
            <width>246</width>
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
            <description>txtRedunDetails</description>
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
            <text>If yes, please provide details</text>
            <textAlign>1</textAlign>
            <top>208</top>
            <width>174</width>
            <isDateDiff>0</isDateDiff>
            <maskedEditBox />
            <maskedEditBox2 />
            <showData />
            <controls />
        </control>
        <control name="optRedundancies" type="tgsYesNo">
            <LostFocusCode />
            <GotFocusCode />
            <ClickCode />
            <enableControls>
                <enableControl>
                    <boundScreen>MLIAB\frmBusSupp.tst</boundScreen>
                    <control>WisLabel6</control>
                    <enable>True</enable>
                </enableControl>
                <enableControl>
                    <boundScreen>MLIAB\frmBusSupp.tst</boundScreen>
                    <control>txtRedunDetails</control>
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
            <columnName>REDUNDANCIES</columnName>
            <description>made any redundancies</description>
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>27</height>
            <left>360</left>
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
            <top>163</top>
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
            <description>optRedundancies</description>
            <maximumTotal>0</maximumTotal>
            <minimumTotal />
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>45</height>
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
            <text>Have you, within the last 60 days, dismissed any staff, made any redundancies or are there any circumstances which may result in dismissal or redundancy of staff?</text>
            <textAlign>1</textAlign>
            <top>155</top>
            <width>326</width>
            <isDateDiff>0</isDateDiff>
            <maskedEditBox />
            <maskedEditBox2 />
            <showData />
            <controls />
        </control>
        <control name="txtEmpDisDetails" type="WisTextBox">
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
            <columnName>EMPDISDETAILS</columnName>
            <description>If yes, please provide details</description>
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
            <left>207</left>
            <font>
                <bold>False</bold>
                <fontName>Tahoma</fontName>
                <italic>False</italic>
                <size>8.25</size>
                <strikeout>False</strikeout>
                <underline>False</underline>
            </font>
            <linkedData />
            <maxLength>100</maxLength>
            <multiLine>False</multiLine>
            <numeric>False</numeric>
            <autoIncrement>False</autoIncrement>
            <maxAutoValue>0</maxAutoValue>
            <properCase>False</properCase>
            <rightToLeft>0</rightToLeft>
            <tabIndex>4</tabIndex>
            <text />
            <textAlign>0</textAlign>
            <top>128</top>
            <width>246</width>
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
            <description>txtEmpDisDetails</description>
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
            <text>If yes, please provide details</text>
            <textAlign>1</textAlign>
            <top>130</top>
            <width>174</width>
            <isDateDiff>0</isDateDiff>
            <maskedEditBox />
            <maskedEditBox2 />
            <showData />
            <controls />
        </control>
        <control name="optEmpDispute" type="tgsYesNo">
            <LostFocusCode />
            <GotFocusCode />
            <ClickCode />
            <enableControls>
                <enableControl>
                    <boundScreen>MLIAB\frmBusSupp.tst</boundScreen>
                    <control>WisLabel4</control>
                    <enable>True</enable>
                </enableControl>
                <enableControl>
                    <boundScreen>MLIAB\frmBusSupp.tst</boundScreen>
                    <control>txtEmpDisDetails</control>
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
            <columnName>EMPDISPUTE</columnName>
            <description>employment dispute claim</description>
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>27</height>
            <left>360</left>
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
            <top>80</top>
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
            <description>optEmpDispute</description>
            <maximumTotal>0</maximumTotal>
            <minimumTotal />
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>42</height>
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
            <text>Are you aware of any existing circumstances which may of could lead to an employment dispute claim under the insurance cover?</text>
            <textAlign>1</textAlign>
            <top>80</top>
            <width>326</width>
            <isDateDiff>0</isDateDiff>
            <maskedEditBox />
            <maskedEditBox2 />
            <showData />
            <controls />
        </control>
        <control name="txtEmps" type="WisTextBox">
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
            <columnName>EMPS</columnName>
            <description>How many employees do you have?</description>
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
            <left>408</left>
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
            <tabIndex>2</tabIndex>
            <text />
            <textAlign>0</textAlign>
            <top>53</top>
            <width>45</width>
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
            <description>txtEmps</description>
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
            <text>How many employees do you have?</text>
            <textAlign>1</textAlign>
            <top>55</top>
            <width>210</width>
            <isDateDiff>0</isDateDiff>
            <maskedEditBox />
            <maskedEditBox2 />
            <showData />
            <controls />
        </control>
        <control name="optBusSuppCover" type="tgsYesNo">
            <LostFocusCode />
            <GotFocusCode />
            <ClickCode />
            <enableControls>
                <enableControl>
                    <boundScreen>MLIAB\frmBusSupp.tst</boundScreen>
                    <control>txtEmps</control>
                    <enable>True</enable>
                </enableControl>
                <enableControl>
                    <boundScreen>MLIAB\frmBusSupp.tst</boundScreen>
                    <control>optEmpDispute</control>
                    <enable>True</enable>
                </enableControl>
                <enableControl>
                    <boundScreen>MLIAB\frmBusSupp.tst</boundScreen>
                    <control>optRedundancies</control>
                    <enable>True</enable>
                </enableControl>
                <enableControl>
                    <boundScreen>MLIAB\frmBusSupp.tst</boundScreen>
                    <control>optRegulations</control>
                    <enable>True</enable>
                </enableControl>
                <enableControl>
                    <boundScreen>MLIAB\frmBusSupp.tst</boundScreen>
                    <control>optDiscussions</control>
                    <enable>True</enable>
                </enableControl>
                <enableControl>
                    <boundScreen>MLIAB\frmBusSupp.tst</boundScreen>
                    <control>optTribunal</control>
                    <enable>True</enable>
                </enableControl>
                <enableControl>
                    <boundScreen>MLIAB\frmBusSupp.tst</boundScreen>
                    <control>optHandS</control>
                    <enable>True</enable>
                </enableControl>
                <enableControl>
                    <boundScreen>MLIAB\frmBusSupp.tst</boundScreen>
                    <control>WisLabel2</control>
                    <enable>True</enable>
                </enableControl>
                <enableControl>
                    <boundScreen>MLIAB\frmBusSupp.tst</boundScreen>
                    <control>WisLabel3</control>
                    <enable>True</enable>
                </enableControl>
                <enableControl>
                    <boundScreen>MLIAB\frmBusSupp.tst</boundScreen>
                    <control>WisLabel5</control>
                    <enable>True</enable>
                </enableControl>
                <enableControl>
                    <boundScreen>MLIAB\frmBusSupp.tst</boundScreen>
                    <control>WisLabel7</control>
                    <enable>True</enable>
                </enableControl>
                <enableControl>
                    <boundScreen>MLIAB\frmBusSupp.tst</boundScreen>
                    <control>WisLabel9</control>
                    <enable>True</enable>
                </enableControl>
                <enableControl>
                    <boundScreen>MLIAB\frmBusSupp.tst</boundScreen>
                    <control>WisLabel11</control>
                    <enable>True</enable>
                </enableControl>
                <enableControl>
                    <boundScreen>MLIAB\frmBusSupp.tst</boundScreen>
                    <control>WisLabel13</control>
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
            <columnName>BUSSUPPCOVER</columnName>
            <description>Do you require Business Support Cover?</description>
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>27</height>
            <left>360</left>
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
            <tabIndex>1</tabIndex>
            <text />
            <top>20</top>
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
            <description>optBusSuppCover</description>
            <maximumTotal>0</maximumTotal>
            <minimumTotal />
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>27</height>
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
            <text>Do you require Business Support Cover?</text>
            <textAlign>16</textAlign>
            <top>20</top>
            <width>244</width>
            <isDateDiff>0</isDateDiff>
            <maskedEditBox />
            <maskedEditBox2 />
            <showData />
            <controls />
        </control>
    </controls>
    <generalSummary>
        <columns />
    </generalSummary>
    <formValidation>
        <validation>
            <controlToValidate>txtDiscussDetails</controlToValidate>
            <operatorType>Not Equal To</operatorType>
            <comparisonType>StaticValue</comparisonType>
            <validationValue />
            <displayMessage>Referal, Please use the Stand-Alone Business Support Screen</displayMessage>
        </validation>
        <validation>
            <controlToValidate>txtEmpDisDetails</controlToValidate>
            <operatorType>Not Equal To</operatorType>
            <comparisonType>StaticValue</comparisonType>
            <validationValue />
            <displayMessage>Referal, Please use the Stand-Alone Business Support Screen</displayMessage>
        </validation>
        <validation>
            <controlToValidate>txtHandSDetails</controlToValidate>
            <operatorType>Not Equal To</operatorType>
            <comparisonType>StaticValue</comparisonType>
            <validationValue />
            <displayMessage>Referal, Please use the Stand-Alone Business Support Screen</displayMessage>
        </validation>
        <validation>
            <controlToValidate>txtRedunDetails</controlToValidate>
            <operatorType>Not Equal To</operatorType>
            <comparisonType>StaticValue</comparisonType>
            <validationValue />
            <displayMessage>Referal, Please use the Stand-Alone Business Support Screen</displayMessage>
        </validation>
        <validation>
            <controlToValidate>txtReguDetails</controlToValidate>
            <operatorType>Not Equal To</operatorType>
            <comparisonType>StaticValue</comparisonType>
            <validationValue />
            <displayMessage>Referal, Please use the Stand-Alone Business Support Screen</displayMessage>
        </validation>
        <validation>
            <controlToValidate>txtTribunalDetails</controlToValidate>
            <operatorType>Not Equal To</operatorType>
            <comparisonType>StaticValue</comparisonType>
            <validationValue />
            <displayMessage>Referal, Please use the Stand-Alone Business Support Screen</displayMessage>
        </validation>
    </formValidation>
    <hideClaim />
</screen>