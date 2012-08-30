
/**
 * @file Plugin for inserting readmore
 */

		CKEDITOR.plugins.add( 'readmore',
		{
				requires  : [ 'fakeobjects', 'htmldataprocessor' ],
				init : function( editor )
				{
						editor.addCss(
								'#system-readmore' +
								'{' +
								'background-image: url(' + CKEDITOR.getUrl( this.path + 'images/readmore.gif' ) + ');' +
								'background-position: center center;' +
								'background-repeat: no-repeat;' +
								'clear: both;' +
								'display: block;' +
								'float: none;' +
								'width: 100%;' +
								'border-top: #999999 1px dotted;' +
								'border-bottom: #999999 1px dotted;' +
								'height: 5px;' +
								'}' +
								'#system-readmore' +
								'{' +
								'border-top: #FF0000 1px dotted;' +
								'border-bottom: #FF0000 1px dotted;' +
								'}'
								);
						// Register the toolbar buttons.
						editor.ui.addButton( 'ReadMore',
						{
								label : "Вставить разделитель 'Читать далее'",
								icon : this.path + 'images/readmoreButton.gif',
								command : 'readmore'
						});
						editor.addCommand( 'readmore',
						{
								exec : function()
								{

										var hrs = editor.document.getElementsByTag( 'hr' );
										for ( var i = 0, len = hrs.count() ; i < len ; i++ )
										{
												var hr = hrs.getItem( i );
												if ( hr.getId() == 'system-readmore')
												{
													alert('В тексте уже присутствует разделитель!');
													return;
												}
										}
										insertComment();
								}
						} );

						function insertComment()
						{
							editor.insertHtml('<hr id="system-readmore" />');
						}
				}
		});
