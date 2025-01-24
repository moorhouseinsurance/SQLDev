<?xml version="1.0" encoding="utf-8"?>
<screen name="frmProfIndm.tst" type="NextPrevious">
    <backColor>
        <r>212</r>
        <g>208</g>
        <b>200</b>
    </backColor>
    <boundScreen />
    <caption>Professional Indemnity</caption>
    <description>Professional Indemnity</description>
    <screenType>0</screenType>
    <projectType>1</projectType>
    <postQuoteNavigationDuplicated>False</postQuoteNavigationDuplicated>
    <foreColor>
        <r>0</r>
        <g>0</g>
        <b>0</b>
    </foreColor>
    <height>277</height>
    <parentID />
    <text>Professional Indemnity</text>
    <width>609</width>
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
        <control name="optDesignYN" type="tgsYesNo">
            <LostFocusCode />
            <GotFocusCode />
            <ClickCode />
            <enableControls>
                <enableControl>
                    <boundScreen>MLIAB\frmProfIndm.tst</boundScreen>
                    <control>optPIYN</control>
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
            <columnName>DESIGNYN</columnName>
            <description>DesignYN</description>
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>36</height>
            <left>261</left>
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
            <top>25</top>
            <width>92</width>
            <showData />
            <objectID>0</objectID>
            <longPropertyID>0</longPropertyID>
            <defaultValue />
            <showHelpText>True</showHelpText>
            <helpText>Do you offer advice, design or certification activities?</helpText>
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
            <description>optDesignYN</description>
            <maximumTotal />
            <minimumTotal />
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>35</height>
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
            <tabIndex>3</tabIndex>
            <text>Do you offer advice, design or certification activities?</text>
            <textAlign>1</textAlign>
            <top>26</top>
            <width>162</width>
            <isDateDiff>0</isDateDiff>
            <maskedEditBox />
            <maskedEditBox2 />
            <showData />
            <controls />
        </control>
        <control name="cboPILevel" type="WisComboBox">
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
            <columnName>MH_PROFESSIONALINDEMNITYLEVEL_ID</columnName>
            <description>PILevel</description>
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>21</height>
            <left>258</left>
            <font>
                <bold>True</bold>
                <fontName>Tahoma</fontName>
                <italic>False</italic>
                <size>8.25</size>
                <strikeout>False</strikeout>
                <underline>False</underline>
            </font>
            <linkedData />
            <listTable>LIST_MH_ProfessionalIndemnityLevel</listTable>
            <maxLength>0</maxLength>
            <numeric>False</numeric>
            <rightToLeft>0</rightToLeft>
            <tabIndex>3</tabIndex>
            <userFilled>False</userFilled>
            <filteredDropdown />
            <text />
            <top>126</top>
            <width>200</width>
            <showData />
            <objectID>0</objectID>
            <longPropertyID>0</longPropertyID>
            <defaultValue />
            <showHelpText>True</showHelpText>
            <helpText>Professional Indemnity Cover Level</helpText>
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
            <description>cboPILevel</description>
            <maximumTotal />
            <minimumTotal />
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>38</height>
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
            <text>Please select the level of Professional Indemnity cover required.</text>
            <textAlign>1</textAlign>
            <top>130</top>
            <width>232</width>
            <isDateDiff>0</isDateDiff>
            <maskedEditBox />
            <maskedEditBox2 />
            <showData />
            <controls />
        </control>
        <control name="optPIYN" type="tgsYesNo">
            <LostFocusCode />
            <GotFocusCode />
            <ClickCode />
            <enableControls>
                <enableControl>
                    <boundScreen>MLIAB\frmProfIndm.tst</boundScreen>
                    <control>cboPILevel</control>
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
            <columnName>PIYN</columnName>
            <description>PIYN</description>
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>27</height>
            <left>262</left>
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
            <tabIndex>2</tabIndex>
            <text />
            <top>78</top>
            <width>92</width>
            <showData />
            <objectID>0</objectID>
            <longPropertyID>0</longPropertyID>
            <defaultValue />
            <showHelpText>True</showHelpText>
            <helpText>Include Professional Indemnity Cover</helpText>
            <required>True</required>
            <displayOnWebpage>True</displayOnWebpage>
            <alwaysVisible>False</alwaysVisible>
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
            <description>optPIYN</description>
            <maximumTotal />
            <minimumTotal />
            <enabled>True</enabled>
            <foreColor>
                <r>0</r>
                <g>0</g>
                <b>0</b>
            </foreColor>
            <height>39</height>
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
            <text>Do you require Professional Indemnity Insurance?</text>
            <textAlign>1</textAlign>
            <top>78</top>
            <width>230</width>
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
    <formValidation />
    <hideClaim />
</screen>