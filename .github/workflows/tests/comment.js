module.exports = async ({github, context}) => {
    const prNumber = context.payload.pull_request.number;
    const newCommentBody = `Test report:\nhttps://lsdaf.github.io/lsdaf_client/reports/report_${context.sha}/\n\n\nYou may need to wait for the github page to be deployed. Check the status of the deployment at https://github.com/LSDAF/lsdaf_client/actions/workflows/pages/pages-build-deployment\n\nTest report log:\nhttps://lsdaf.github.io/lsdaf_client/reports/report_${context.sha}/godot_report_log.html/`;

    // Fetch existing comments
    const { data: comments } = await github.rest.issues.listComments({
        ...context.repo,
        issue_number: prNumber,
    });

    // Check if the comment already exists
    const existingComment = comments.find(comment => comment.body.includes('https://lsdaf.github.io/lsdaf_client/reports/report_'));

    if (existingComment) {
        // Update the existing comment
        await github.rest.issues.updateComment({
            ...context.repo,
            comment_id: existingComment.id,
            body: newCommentBody,
        });
    } else {
        // Create a new comment
        await github.rest.issues.createComment({
            ...context.repo,
            issue_number: prNumber,
            body: newCommentBody,
        });
    }
}
