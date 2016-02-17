package org.sqf.oxy.util;

import ro.sync.exml.workspace.api.PluginWorkspace;
import ro.sync.exml.workspace.api.PluginWorkspaceProvider;
import ro.sync.exml.workspace.api.editor.WSEditor;
import ro.sync.exml.workspace.api.editor.page.WSEditorPage;
import ro.sync.exml.workspace.api.editor.page.author.WSAuthorEditorPage;

public class StaticFct {
	
	
	public static String getAuthorName() {
		WSEditor editorAccess = PluginWorkspaceProvider.getPluginWorkspace().getCurrentEditorAccess(PluginWorkspace.MAIN_EDITING_AREA);
		if (editorAccess != null) {
			final WSEditorPage currentPage = editorAccess.getCurrentPage();
			if (currentPage instanceof WSAuthorEditorPage) {
				return ((WSAuthorEditorPage)currentPage).getAuthorAccess().getReviewController().getReviewerAuthorName();
			}
		}
		return null;
	}
	
	
}
