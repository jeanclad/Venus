<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<document type="com.apple.InterfaceBuilder3.CocoaTouch.Storyboard.XIB" version="2.0" toolsVersion="3084" systemVersion="12C3103" targetRuntime="iOS.CocoaTouch" propertyAccessControl="none" initialViewController="2">
    <dependencies>
        <deployment version="1280" identifier="iOS"/>
        <plugIn identifier="com.apple.InterfaceBuilder.IBCocoaTouchPlugin" version="2083"/>
    </dependencies>
    <scenes>
        <!--Venus View Controller-->
        <scene sceneID="5">
            <objects>
                <viewController id="2" customClass="VenusViewController" sceneMemberID="viewController">
                    <view key="view" contentMode="scaleToFill" id="3">
                        <rect key="frame" x="0.0" y="0.0" width="480" height="320"/>
                        <autoresizingMask key="autoresizingMask" flexibleMaxX="YES" flexibleMaxY="YES"/>
                        <subviews>
                            <button opaque="NO" contentMode="scaleToFill" contentHorizontalAlignment="center" contentVerticalAlignment="center" buttonType="roundedRect" lineBreakMode="middleTruncation" id="qfO-Zh-9kF">
                                <rect key="frame" x="131" y="113" width="219" height="44"/>
                                <accessibility key="accessibilityConfiguration" label=""/>
                                <fontDescription key="fontDescription" type="boldSystem" pointSize="15"/>
                                <state key="normal" title="Touch to select your image">
                                    <color key="titleColor" red="0.19607843459999999" green="0.30980393290000002" blue="0.52156865600000002" alpha="1" colorSpace="calibratedRGB"/>
                                    <color key="titleShadowColor" white="0.5" alpha="1" colorSpace="calibratedWhite"/>
                                </state>
                                <state key="highlighted">
                                    <color key="titleColor" white="1" alpha="1" colorSpace="calibratedWhite"/>
                                </state>
                                <connections>
                                    <action selector="buttonPressed:" destination="2" eventType="touchUpInside" id="B3P-rF-S3G"/>
                                </connections>
                            </button>
                            <button hidden="YES" opaque="NO" contentMode="scaleToFill" contentHorizontalAlignment="center" contentVerticalAlignment="center" buttonType="roundedRect" lineBreakMode="middleTruncation" id="8tN-5i-JTn">
                                <rect key="frame" x="214" y="176" width="128" height="44"/>
                                <fontDescription key="fontDescription" type="boldSystem" pointSize="15"/>
                                <state key="normal" title="Hidden Button">
                                    <color key="titleColor" red="0.19607843459999999" green="0.30980393290000002" blue="0.52156865600000002" alpha="1" colorSpace="calibratedRGB"/>
                                    <color key="titleShadowColor" white="0.5" alpha="1" colorSpace="calibratedWhite"/>
                                </state>
                                <state key="highlighted">
                                    <color key="titleColor" white="1" alpha="1" colorSpace="calibratedWhite"/>
                                </state>
                                <connections>
                                    <segue destination="woJ-Tj-H4O" kind="modal" identifier="VenusFilmViewControllerId" id="ufB-HS-i5j"/>
                                </connections>
                            </button>
                            <button opaque="NO" contentMode="scaleToFill" contentHorizontalAlignment="center" contentVerticalAlignment="center" buttonType="roundedRect" lineBreakMode="middleTruncation" id="xq5-tm-9D4">
                                <rect key="frame" x="20" y="257" width="66" height="44"/>
                                <fontDescription key="fontDescription" type="boldSystem" pointSize="15"/>
                                <state key="normal" title="Paper">
                                    <color key="titleColor" red="0.19607843459999999" green="0.30980393290000002" blue="0.52156865600000002" alpha="1" colorSpace="calibratedRGB"/>
                                    <color key="titleShadowColor" white="0.5" alpha="1" colorSpace="calibratedWhite"/>
                                </state>
                                <state key="highlighted">
                                    <color key="titleColor" white="1" alpha="1" colorSpace="calibratedWhite"/>
                                </state>
                            </button>
                            <button opaque="NO" contentMode="scaleToFill" contentHorizontalAlignment="center" contentVerticalAlignment="center" buttonType="roundedRect" lineBreakMode="middleTruncation" id="mnu-dI-I0d">
                                <rect key="frame" x="123" y="257" width="91" height="44"/>
                                <fontDescription key="fontDescription" type="boldSystem" pointSize="15"/>
                                <state key="normal" title="Chemical">
                                    <color key="titleColor" red="0.19607843459999999" green="0.30980393290000002" blue="0.52156865600000002" alpha="1" colorSpace="calibratedRGB"/>
                                    <color key="titleShadowColor" white="0.5" alpha="1" colorSpace="calibratedWhite"/>
                                </state>
                                <state key="highlighted">
                                    <color key="titleColor" white="1" alpha="1" colorSpace="calibratedWhite"/>
                                </state>
                            </button>
                            <button opaque="NO" contentMode="scaleToFill" contentHorizontalAlignment="center" contentVerticalAlignment="center" buttonType="roundedRect" lineBreakMode="middleTruncation" id="ddt-cD-6Nz">
                                <rect key="frame" x="279" y="257" width="71" height="44"/>
                                <fontDescription key="fontDescription" type="boldSystem" pointSize="15"/>
                                <state key="normal" title="Album">
                                    <color key="titleColor" red="0.19607843459999999" green="0.30980393290000002" blue="0.52156865600000002" alpha="1" colorSpace="calibratedRGB"/>
                                    <color key="titleShadowColor" white="0.5" alpha="1" colorSpace="calibratedWhite"/>
                                </state>
                                <state key="highlighted">
                                    <color key="titleColor" white="1" alpha="1" colorSpace="calibratedWhite"/>
                                </state>
                            </button>
                            <button opaque="NO" contentMode="scaleToFill" contentHorizontalAlignment="center" contentVerticalAlignment="center" buttonType="roundedRect" lineBreakMode="middleTruncation" id="Ygd-of-EMH">
                                <rect key="frame" x="397" y="257" width="63" height="44"/>
                                <fontDescription key="fontDescription" type="boldSystem" pointSize="15"/>
                                <state key="normal" title="Store">
                                    <color key="titleColor" red="0.19607843459999999" green="0.30980393290000002" blue="0.52156865600000002" alpha="1" colorSpace="calibratedRGB"/>
                                    <color key="titleShadowColor" white="0.5" alpha="1" colorSpace="calibratedWhite"/>
                                </state>
                                <state key="highlighted">
                                    <color key="titleColor" white="1" alpha="1" colorSpace="calibratedWhite"/>
                                </state>
                            </button>
                        </subviews>
                        <color key="backgroundColor" white="1" alpha="1" colorSpace="custom" customColorSpace="calibratedWhite"/>
                        <simulatedOrientationMetrics key="simulatedOrientationMetrics" orientation="landscapeRight"/>
                    </view>
                    <toolbarItems/>
                    <nil key="simulatedStatusBarMetrics"/>
                    <simulatedOrientationMetrics key="simulatedOrientationMetrics" orientation="landscapeRight"/>
                    <simulatedScreenMetrics key="simulatedDestinationMetrics"/>
                    <connections>
                        <outlet property="selectImageButton" destination="qfO-Zh-9kF" id="xLT-nU-ehe"/>
                    </connections>
                </viewController>
                <placeholder placeholderIdentifier="IBFirstResponder" id="4" sceneMemberID="firstResponder"/>
            </objects>
            <point key="canvasLocation" x="58" y="25"/>
        </scene>
        <!--Venus Film View Controller-->
        <scene sceneID="Vmc-2D-tBP">
            <objects>
                <viewController id="woJ-Tj-H4O" customClass="VenusFilmViewController" sceneMemberID="viewController">
                    <view key="view" contentMode="scaleToFill" id="4zG-TM-X6Y">
                        <rect key="frame" x="0.0" y="0.0" width="480" height="320"/>
                        <autoresizingMask key="autoresizingMask" flexibleMaxX="YES" flexibleMaxY="YES"/>
                        <subviews>
                            <label opaque="NO" clipsSubviews="YES" userInteractionEnabled="NO" contentMode="center" text="DARKROOM IN USE" lineBreakMode="tailTruncation" baselineAdjustment="alignBaselines" adjustsFontSizeToFit="NO" id="RNY-DG-vlA">
                                <rect key="frame" x="159" y="11" width="162" height="21"/>
                                <fontDescription key="fontDescription" name="Helvetica" family="Helvetica" pointSize="17"/>
                                <color key="textColor" cocoaTouchSystemColor="darkTextColor"/>
                                <nil key="highlightedColor"/>
                            </label>
                            <navigationBar contentMode="scaleToFill" id="0mk-kc-bT8">
                                <rect key="frame" x="0.0" y="0.0" width="480" height="44"/>
                                <autoresizingMask key="autoresizingMask" widthSizable="YES" flexibleMaxY="YES"/>
                                <items>
                                    <navigationItem title="Title" id="CTN-IY-XVu">
                                        <barButtonItem key="leftBarButtonItem" title="Cancel" id="0AJ-lu-uSL">
                                            <connections>
                                                <action selector="buttonPressed:" destination="woJ-Tj-H4O" id="9Ph-TN-zKU"/>
                                            </connections>
                                        </barButtonItem>
                                    </navigationItem>
                                </items>
                            </navigationBar>
                            <tableView clipsSubviews="YES" contentMode="scaleToFill" alwaysBounceVertical="YES" dataMode="prototypes" style="plain" rowHeight="44" sectionHeaderHeight="22" sectionFooterHeight="22" id="yHI-a7-WRc">
                                <rect key="frame" x="20" y="62" width="440" height="238"/>
                                <autoresizingMask key="autoresizingMask" widthSizable="YES" heightSizable="YES"/>
                                <color key="backgroundColor" white="1" alpha="1" colorSpace="calibratedWhite"/>
                                <connections>
                                    <outlet property="dataSource" destination="woJ-Tj-H4O" id="TF8-CM-POJ"/>
                                    <outlet property="delegate" destination="woJ-Tj-H4O" id="WJh-Y0-dnN"/>
                                </connections>
                            </tableView>
                        </subviews>
                        <color key="backgroundColor" white="1" alpha="1" colorSpace="custom" customColorSpace="calibratedWhite"/>
                        <simulatedOrientationMetrics key="simulatedOrientationMetrics" orientation="landscapeRight"/>
                    </view>
                    <nil key="simulatedStatusBarMetrics"/>
                    <simulatedOrientationMetrics key="simulatedOrientationMetrics" orientation="landscapeRight"/>
                    <simulatedScreenMetrics key="simulatedDestinationMetrics"/>
                    <connections>
                        <outlet property="cancelButton" destination="0AJ-lu-uSL" id="Uor-CQ-utx"/>
                    </connections>
                </viewController>
                <placeholder placeholderIdentifier="IBFirstResponder" id="0ns-yF-99Q" userLabel="First Responder" sceneMemberID="firstResponder"/>
            </objects>
            <point key="canvasLocation" x="687" y="25"/>
        </scene>
    </scenes>
    <classes>
        <class className="VenusFilmViewController" superclassName="UIViewController">
            <source key="sourceIdentifier" type="project" relativePath="./Classes/VenusFilmViewController.h"/>
            <relationships>
                <relationship kind="action" name="buttonPressed:" candidateClass="UIBarButtonItem"/>
                <relationship kind="action" name="cancel:"/>
                <relationship kind="outlet" name="cancelButton" candidateClass="UIBarButtonItem"/>
            </relationships>
        </class>
        <class className="VenusViewController" superclassName="UIViewController">
            <source key="sourceIdentifier" type="project" relativePath="./Classes/VenusViewController.h"/>
            <relationships>
                <relationship kind="action" name="buttonPressed:" candidateClass="UIButton"/>
                <relationship kind="outlet" name="selectImageButton" candidateClass="UIButton"/>
            </relationships>
        </class>
    </classes>
    <simulatedMetricsContainer key="defaultSimulatedMetrics">
        <simulatedStatusBarMetrics key="statusBar"/>
        <simulatedOrientationMetrics key="orientation"/>
        <simulatedScreenMetrics key="destination" type="retina4"/>
    </simulatedMetricsContainer>
</document>